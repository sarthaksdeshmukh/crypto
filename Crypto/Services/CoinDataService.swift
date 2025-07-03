//
//  CoinDataService.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 11/05/25.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    
    var cancellables = Set<AnyCancellable>()
    var coinSubscriptions: AnyCancellable?
    
    init (){
        getCoins()
    }
    
     func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
         
        coinSubscriptions = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnCoins)in
                self?.allCoins = returnCoins
                self?.coinSubscriptions?.cancel()
                
            })
    }
}
