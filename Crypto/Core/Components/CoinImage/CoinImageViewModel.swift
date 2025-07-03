//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 14/05/25.
//
import SwiftUI
import Foundation
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let dataService: CoinImageService
    private let coin: CoinModel
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink {[weak self] (_) in
                self?.isLoading = false
            } receiveValue: {[weak self] (returnImage) in
                self?.image = returnImage
            }.store(in: &cancellable)
        }
    }
    
