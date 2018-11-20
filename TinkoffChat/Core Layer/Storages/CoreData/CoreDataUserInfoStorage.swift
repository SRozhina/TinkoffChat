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
        guard let fetchRequest = container.managedObjectModel.fetchRequestFromTemplate(withName: "User",
                                                                                       substitutionVariables: ["NAME": newUserInfo.name])
            as? NSFetchRequest<UserInfoEntity> else { return }
        saveUser(newUserInfo, with: fetchRequest, isProfile: false)
    }
    
    func saveUserProfile(_ newUserInfo: UserInfo) {
        guard let fetchRequest = container.managedObjectModel.fetchRequestTemplate(forName: "UserProfile")
            as? NSFetchRequest<UserInfoEntity> else { return }
        saveUser(newUserInfo, with: fetchRequest, isProfile: true)
    }
    
    private func saveUser(_ newUserInfo: UserInfo, with fetchRequest: NSFetchRequest<UserInfoEntity>, isProfile: Bool) {
        let context = container.viewContext
        context.performAndWait {
            let users = try? context.fetch(fetchRequest)
            guard let userEntity = users?.first
                ?? NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfoEntity.self),
                                                       into: context) as? UserInfoEntity else { return }
            if isProfile {
                userEntity.id = 0
            }
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
}
