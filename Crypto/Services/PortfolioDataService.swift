//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 24/05/25.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container:NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var saveEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading core data \(error)")
            }
            self.getPortfolio()
        }
    }
    // MARK: PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        // check coin is already in portfolio
        if let entity = saveEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                upate(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else  {
            add(coin: coin, amount: amount)
        }
    }
    
    
    // Mark: PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            saveEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entity \(error)")
        }
    }
    
    private func add(coin: CoinModel,amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChange()
    }
    
    private func upate(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChange()
    }
    
    
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChange()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to core Data. \(error)")
        }
    }
    
    private func applyChange() {
        save()
        getPortfolio()
    }
}

