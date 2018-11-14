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
    
    init(userInfoPathProvider: IUserInfoPathProvider) {
        self.userInfoPathProvider = userInfoPathProvider
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinkoffChat")
        container.loadPersistentStores(completionHandler: { _, _ in })
        return container
    }()
    
    func getUserInfo(_ completion: @escaping (UserInfo) -> Void) {
        container.performBackgroundTask { backgroundContext in
            let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
            let result = try? backgroundContext.fetch(fetchRequest)
            
            let userInfo = self.makeUserInfo(from: result?.last)
            
            DispatchQueue.main.async {
                completion(userInfo)
            }
        }
    }
    
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping SaverCompletion) {
        container.performBackgroundTask { backgroundContext in
            let userInfoEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfoEntity.self),
                                                                     into: backgroundContext) as? UserInfoEntity
            userInfoEntity?.id = 0
            userInfoEntity?.name = userInfo.name
            userInfoEntity?.info = userInfo.info
            if let image = userInfo.avatar,
                let imageData = UIImageJPEGRepresentation(image, 1) {
                try? imageData.write(to: self.userInfoPathProvider.avatarFilePath)
            }
            userInfoEntity?.avatar = self.userInfoPathProvider.avatarFilePath
            
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.error)
                }
            }
            
        }
    }
    
    private func makeUserInfo(from userInfoEntity: UserInfoEntity?) -> UserInfo {
        let name = userInfoEntity?.name ?? "No name"
        let info = userInfoEntity?.info ?? ""
        let avatarData = try? Data(contentsOf: self.userInfoPathProvider.avatarFilePath)
        let avatar = avatarData != nil ? UIImage(data: avatarData!) : UIImage(named: "avatar_placeholder")
        return UserInfo(name: name, info: info, avatar: avatar)
    }
}
