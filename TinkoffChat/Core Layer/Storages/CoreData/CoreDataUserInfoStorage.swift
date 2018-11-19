//
//  CoreDataUserInfoStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 03/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataUserInfoStorage: IUserInfoStorage {
    private let userInfoPathProvider: IUserInfoPathProvider
    private let container: NSPersistentContainer
    
    init(userInfoPathProvider: IUserInfoPathProvider,
         container: NSPersistentContainer) {
        self.userInfoPathProvider = userInfoPathProvider
        self.container = container
    }
    
    func saveUser(_ newUserInfo: UserInfo) {
         let predicate = NSPredicate(format: "name==%@", "\(newUserInfo.name)")
        saveUser(newUserInfo, with: predicate)
    }
    
    func saveUserProfile(_ newUserInfo: UserInfo) {
        let predicate = NSPredicate(format: "id==%@", 0)
        saveUser(newUserInfo, with: predicate)
    }
    
    private func saveUser(_ newUserInfo: UserInfo, with predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
        fetchRequest.predicate = predicate
        let context = container.viewContext
        context.performAndWait {
            let users = try? context.fetch(fetchRequest)
            guard let userEntity = users?.first else { return }
            userEntity.name = newUserInfo.name
            userEntity.info = newUserInfo.info
            if let image = newUserInfo.avatar,
                let imageData = UIImageJPEGRepresentation(image, 1) {
                try? imageData.write(to: self.userInfoPathProvider.avatarFilePath)
            }
            userEntity.avatar = self.userInfoPathProvider.avatarFilePath
            try? context.save()
        }
    }
    
    func createUserProfile() {
        //TODO make conversation not required
        let context = container.viewContext
        //context.performAndWait {
            let userEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfoEntity.self),
                                                                 into: context) as? UserInfoEntity
            userEntity?.id = 0
            userEntity?.name = "No name"
            userEntity?.info = ""
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        //}
    }
}
