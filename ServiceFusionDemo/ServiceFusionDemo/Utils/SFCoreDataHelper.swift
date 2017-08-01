//
//  SFCoreDataHelper.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import Foundation
import CoreData

class SFCoreDataHelper {
    
    // MARK: - # Variables
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    
    public var handlerCompletionClosure: (() -> ())?
    
    // MARK: - # Singleton
    
    open static let shared = SFCoreDataHelper()
    
    init() {
        guard let modelURL = Bundle.main.url(forResource: SFConstants.CoreData.modelName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("\(SFConstants.CoreData.modelName).sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                if self.handlerCompletionClosure != nil {
                    DispatchQueue.main.sync(execute: self.handlerCompletionClosure!)
                }
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    // MARK: - # Public Functions
    
    public func getManagedObjectContext() -> NSManagedObjectContext {
        return managedObjectContext
    }
}
