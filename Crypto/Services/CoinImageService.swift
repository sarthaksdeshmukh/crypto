//
//  CoinImageService.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 14/05/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName : String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
            print("Retrived image from file manager")
        } else {
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({
                (data) -> UIImage in
                return UIImage(data: data)!
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnImage) in
//                guard let downloadImage = returnImage else  { return }
                self?.image = returnImage
                self?.imageSubscription?.cancel()
                self?.fileManager.saveImage(image: returnImage, imageName: self!.imageName, folderName: self!.folderName)
            })
    }
}
