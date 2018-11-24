//
//  UserInfoStorageProvider.swift
//  TinkoffChat
//
//  Created by Sofia on 21/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class UserInfoStorageProvider: IUserInfoStorageProvider {
    private let userInfoPathProvider: IUserInfoPathProvider
    private let GCDStorage: GCDUserInfoStorage
    private let operationsStorage: OperationsUserInfoStorage
    //private let coreDataStorage: CoreDataExtendedUserInfoStorage
    private let coreDataStorage: CoreDataUserInfoStorage
    
    init(userInfoPathProvider: IUserInfoPathProvider, container: NSPersistentContainer) {
        self.userInfoPathProvider = userInfoPathProvider
        self.GCDStorage = GCDUserInfoStorage(userInfoPathProvider: userInfoPathProvider)
        self.operationsStorage = OperationsUserInfoStorage(userInfoPathProvider: userInfoPathProvider)
        //self.coreDataStorage = CoreDataExtendedUserInfoStorage(userInfoPathProvider: userInfoPathProvider)
        self.coreDataStorage = CoreDataUserInfoStorage(userInfoPathProvider: userInfoPathProvider, container: container)
    }
    
    func getUserInfoStorage(storageType: StorageType) -> IUserInfoStorage {
        switch storageType {
//        case .GCD:
//            return GCDStorage
//        case .Operations:
//            return operationsStorage
        default:
            return coreDataStorage
        }
    }
}
