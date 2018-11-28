//
//  UserProfileDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    
    func setupService() {
        let predicate = NSPredicate(format: "isProfile == %@", NSNumber(value: true))
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
    
    func getUserProfileInfo() -> UserInfo {
        if let userInfoEntity = fetchResultsController.fetchedObjects?.first {
            return userInfoConverter.makeUserInfo(from: userInfoEntity)
        }
        return UserInfo(name: "No name", info: "Profile", avatar: UIImage(named: "avatar_placeholder"))
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
        case .update, .insert:
            guard let userInfoEntity = anObject as? UserInfoEntity else { return }
            let userInfo = userInfoConverter.makeUserInfo(from: userInfoEntity)
            userDelegate?.updateUser(with: userInfo)
        default:
            break
        }
    }
}
