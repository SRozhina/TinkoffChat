//
//  UserDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

protocol UserProfileDataChangedServiceDelegate: class {
    func updateUser()
}

protocol IUserProfileDataChangedService {
    func setupService()
    func getUserProfileInfo() -> UserInfo?
    var userDelegate: UserProfileDataChangedServiceDelegate? { get set }
}

class UserProfileDataChangedService: NSObject, NSFetchedResultsControllerDelegate, IUserProfileDataChangedService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<UserInfoEntity>!
    private let userInfoConverter: IUserInfoConverter
    weak var userDelegate: UserProfileDataChangedServiceDelegate?
    
    init(container: NSPersistentContainer,
         userInfoConverter: IUserInfoConverter) {
        self.context = container.viewContext
        self.userInfoConverter = userInfoConverter
    }
    
    func setupService() {
        let predicate = NSPredicate(format: "id==0")
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
    
    func getUserProfileInfo() -> UserInfo? {
        //Create new userinfo if there is no in storage
        guard let userInfoEntity = fetchResultsController.fetchedObjects?.first else { return nil }
        return userInfoConverter.makeUserInfo(from: userInfoEntity)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .update:
            userDelegate?.updateUser()
        default:
            break
        }
    }
}
