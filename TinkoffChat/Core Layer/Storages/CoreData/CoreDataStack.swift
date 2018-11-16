//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Sofia on 03/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    private let userInfoPathProvider: IUserInfoPathProvider
    private let modelName = "TinkoffChat"
    
    init(userInfoPathProvider: IUserInfoPathProvider) {
        self.userInfoPathProvider = userInfoPathProvider
    }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("No model in the app")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Cannot load data model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: userInfoPathProvider.storeFilePath,
                                                              options: nil)
        } catch {
            fatalError("Cannot load persistent store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    func saveMainContext() throws {
        if managedObjectContext.hasChanges {
            try managedObjectContext.save()
        }
    }
}
