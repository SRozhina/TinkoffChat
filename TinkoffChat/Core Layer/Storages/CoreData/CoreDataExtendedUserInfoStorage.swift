//
//  CoreDataExtendedUserInfoStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 03/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataExtendedUserInfoStorage: IUserInfoStorageOld {
    private let userInfoPathProvider: IUserInfoPathProvider
    private lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack(userInfoPathProvider: userInfoPathProvider)
    }()
    
    init(userInfoPathProvider: IUserInfoPathProvider) {
        self.userInfoPathProvider = userInfoPathProvider
    }
    
    func getUserInfo(_ completion: @escaping (UserInfo) -> Void) {
        let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
        let result = try? coreDataStack.managedObjectContext.fetch(fetchRequest)
        let userInfo = makeUserInfo(from: result?.last)
        completion(userInfo)
    }
    
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping SaverCompletion) {
        let userInfoEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfoEntity.self),
                                                                 into: coreDataStack.managedObjectContext) as? UserInfoEntity
        userInfoEntity?.name = userInfo.name
        userInfoEntity?.info = userInfo.info
        if let image = userInfo.avatar,
            let imageData = UIImageJPEGRepresentation(image, 1) {
            try? imageData.write(to: self.userInfoPathProvider.avatarFilePath)
        }
        userInfoEntity?.avatar = self.userInfoPathProvider.avatarFilePath
            
        do {
            try coreDataStack.saveMainContext()
            completion(.success)
        } catch {
            completion(.error)
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
