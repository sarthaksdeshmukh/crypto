//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 11/05/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticsModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portFolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let markerDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingreversed, price, pricereversed
    }
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers() {
        
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
               
            }
            .store(in: &cancellables)
        
       
        //updates portfolio coins
        
        $allCoins
            .combineLatest(portfolioDataService.$saveEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink {[weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portFolioCoins = self.sortPortfolioCoinsIfneeded(coins: returnedCoins)
            }.store(in: &cancellables)
        
        // update market data
        
        markerDataService.$marketData
            .combineLatest($portFolioCoins)
            .map(mapGlobalMarketData)
            .sink {  [weak self] returnStats in
                self?.statistics = returnStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        markerDataService.getCoins()
        HapticManager.notification(type: .success)
    }
    
    private func mapAllCoinsToPortfolioCoins(coinModels: [CoinModel],portfolioEntities:[PortfolioEntity]) -> [CoinModel]{
        coinModels
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else  {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?,portfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap,percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
            
            let previousValue = currentValue / (1+percentageChange)
            return previousValue
        }.reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue)/previousValue) * 100
        
        
        let portfolio = StatisticsModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel],sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        //sort
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort {
        case .rank,.holdings :
             coins.sort(by: { $0.rank < $1.rank})
        case .rankReversed, .holdingreversed:
             coins.sort(by: { $0.rank > $1.rank})
        case .price:
             coins.sort(by: { $0.currentPrice < $1.currentPrice})
        case .pricereversed:
              coins.sort(by: { $0.currentPrice > $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfneeded(coins: [CoinModel])-> [CoinModel] {
            // will only sort by holdings or reverseHoldings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingreversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default :
            return coins
        }
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter {
            (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
}

