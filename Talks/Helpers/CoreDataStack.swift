//
//  CoreDataStack.swift
//  Talks
//
//  Created by Denis Garifyanov on 20/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    private var storeUrl: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("MyStore.sqlite")
    }

    private let dataModelName = "Talks"
    private let dataModelExtension = "momd"

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    private lazy var persitentSotreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()

    lazy public var masterContext: NSManagedObjectContext? = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persitentSotreCoordinator
        masterContext.mergePolicy = NSMergePolicy.overwrite
        return masterContext
    }()

    lazy public var mainContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.masterContext
        context.mergePolicy = NSMergePolicy.overwrite
        return context

    }()
    lazy var saveContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.mergePolicy = NSMergePolicy.overwrite
        context.undoManager = nil
        return context
    }()

    typealias SaveComplition = () -> Void

    func performSave(with context: NSManagedObjectContext, complition: SaveComplition? = nil) {
        context.perform {
            guard context.hasChanges else {
                complition?()
                return
            }
            do {
                try context.save()
            } catch {
                print("Context save error: \(error)")
            }
            if let parentContext = context.parent {
                self.performSave(with: parentContext, complition: complition)
            } else {
                complition?()
            }
        }
    }
}
