//
//  UserDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class UserProfileDataService: NSObject, NSFetchedResultsControllerDelegate, IUserProfileDataService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<UserInfoEntity>!
    private let userInfoConverter: IUserInfoConverter
    private let conversationsStorage: IConversationsStorage
    private let userInfoStorage: IUserInfoStorage
    weak var userDelegate: UserProfileDataServiceDelegate?
    
    init(container: NSPersistentContainer,
         userInfoConverter: IUserInfoConverter,
         conversationsStorage: IConversationsStorage,
         userInfoStorage: IUserInfoStorage) {
        self.context = container.viewContext
        self.userInfoConverter = userInfoConverter
        self.conversationsStorage = conversationsStorage
        self.userInfoStorage = userInfoStorage
    }
    
    //TODO stop call setup every time - do setup one time in DI container
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
        guard let userInfoEntity = fetchResultsController.fetchedObjects?.first else { return nil }
        return userInfoConverter.makeUserInfo(from: userInfoEntity)
    }
    
    func saveUserProfileInfo(_ userInfo: UserInfo) {
        userInfoStorage.saveUserProfile(userInfo)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let userInfoEntity = anObject as? UserInfoEntity else { return }
            let userInfo = userInfoConverter.makeUserInfo(from: userInfoEntity)
            userDelegate?.updateUser(with: userInfo)
        default:
            break
        }
    }
}