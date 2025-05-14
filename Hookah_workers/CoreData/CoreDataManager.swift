//
//  CoreDataManager.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Hookah_workers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func savePadding(paddingModel: PaddingModel, completion: @escaping (Error?) -> Void) {
        let id = paddingModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Padding> = Padding.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let padding: Padding

                if let existingPadding = results.first {
                    padding = existingPadding
                } else {
                    padding = Padding(context: backgroundContext)
                    padding.id = id
                }
                padding.fillingDescription = paddingModel.fillingDescription
                padding.flavors = paddingModel.flavors
                padding.price = paddingModel.price
                padding.rating = paddingModel.rating
                padding.strength = paddingModel.strength
                padding.taste = paddingModel.taste
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchPaddings(completion: @escaping ([PaddingModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Padding> = Padding.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var paddingModels: [PaddingModel] = []
                for result in results {
                    let paddingModel = PaddingModel(id: result.id, strength: result.strength, fillingDescription: result.fillingDescription, price: result.price, taste: result.taste, flavors: result.flavors ?? [""], rating: result.rating)
                    paddingModels.append(paddingModel)
                }
                completion(paddingModels, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func updatePaddingRating(by id: UUID, newRating: Double, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Padding> = Padding.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                
                if let padding = results.first {
                    padding.rating = newRating
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Padding not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func removePadding(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Padding> = Padding.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                
                if let padding = results.first {
                    backgroundContext.delete(padding)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    // Padding with the given ID not found
                    DispatchQueue.main.async {
                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Padding not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
