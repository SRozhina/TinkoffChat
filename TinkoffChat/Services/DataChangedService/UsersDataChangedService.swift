//
//  UsersDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class UsersDataChangedService: NSObject, NSFetchedResultsControllerDelegate, IUsersDataChangedService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<UserInfoEntity>!
    weak var usersDelegate: UsersDataChangedServiceDelegate?
    
    init(container: NSPersistentContainer) {
        self.context = container.viewContext
    }
    
    func setupService() {
        let predicate = NSPredicate(format: "conversation.isOnline==%@", NSNumber(value: true))
        let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UserInfoEntity.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        
        fetchResultsController = NSFetchedResultsController<UserInfoEntity>(fetchRequest: fetchRequest,
                                                                            managedObjectContext: context,
                                                                            sectionNameKeyPath: nil,
                                                                            cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let indexPath = indexPath, let userName = (anObject as? UserInfoEntity)?.name else { return }
            usersDelegate?.updateUser(with: userName, at: indexPath)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            usersDelegate?.insertUser(at: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            usersDelegate?.deleteUser(at: indexPath)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath,
                let userName = (anObject as? UserInfoEntity)?.name else { return }
            usersDelegate?.moveUser(with: userName, from: indexPath, to: newIndexPath)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        usersDelegate?.startUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        usersDelegate?.endUpdates()
    }
}
