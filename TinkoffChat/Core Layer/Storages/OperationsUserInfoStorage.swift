//
//  OperationsUserInfoStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 21/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import UIKit

class OperationsUserInfoStorage: IUserInfoStorageOld {
    private let userInfoPathProvider: IUserInfoPathProvider
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    init(userInfoPathProvider: IUserInfoPathProvider) {
        self.userInfoPathProvider = userInfoPathProvider
    }
    
    func getUserInfo(_ completion: @escaping (UserInfo) -> Void) {
        let loadFileOperation = LoadFileOperation(userInfoPathProvider: userInfoPathProvider)
        loadFileOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(loadFileOperation.userInfo)
            }
        }
        operationQueue.addOperation(loadFileOperation)
    }
    
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping SaverCompletion) {
        let loadFileOperation = LoadFileOperation(userInfoPathProvider: userInfoPathProvider)
        let saveFileOperation = SaveFileOperation(userInfoPathProvider: userInfoPathProvider,
                                                  userInfo: userInfo)
        saveFileOperation.addDependency(loadFileOperation)
        saveFileOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(saveFileOperation.result)
            }
        }
        operationQueue.addOperations([loadFileOperation, saveFileOperation], waitUntilFinished: false)
    }
}

private class SaveFileOperation: Operation {
    private let userInfo: UserInfo
    private let userInfoPathProvider: IUserInfoPathProvider
    private var _previousUserInfo: UserInfo?
    private var previousUserInfo: UserInfo? {
        get {
            if let userInfo = _previousUserInfo { return userInfo }
            if let operation = dependencies.first(where: { $0 is LoadFileOperation }) as? LoadFileOperation {
                return operation.userInfo
            }
            return nil
        }
        set {
            _previousUserInfo = newValue
        }
    }
    var result: Result = .error
    
    init(userInfoPathProvider: IUserInfoPathProvider, userInfo: UserInfo) {
        self.userInfoPathProvider = userInfoPathProvider
        self.userInfo = userInfo
    }
    
    override func main() {
        do {
            if previousUserInfo?.name != userInfo.name {
                try userInfo.name.write(to: self.userInfoPathProvider.userNameFilePath, atomically: false, encoding: .utf8)
            }
            if previousUserInfo?.info != userInfo.info {
                try userInfo.info.write(to: self.userInfoPathProvider.infoFilePath, atomically: false, encoding: .utf8)
            }
            if previousUserInfo?.avatar != userInfo.avatar {
                if let image = userInfo.avatar,
                    let imageData = UIImageJPEGRepresentation(image, 1) {
                    try imageData.write(to: self.userInfoPathProvider.avatarFilePath)
                }
            }
            result = .success
        } catch {
            result = .error
        }
    }
}

private class LoadFileOperation: Operation {
    var userInfo: UserInfo = UserInfo(name: "No name", avatar: UIImage(named: "avatar_placeholder"))
    private let userInfoPathProvider: IUserInfoPathProvider
    
    init(userInfoPathProvider: IUserInfoPathProvider) {
        self.userInfoPathProvider = userInfoPathProvider
    }
    
    override func main() {
        if let userName = try? String(contentsOf: self.userInfoPathProvider.userNameFilePath) {
            userInfo.name = userName
        }
        let info = try? String(contentsOf: self.userInfoPathProvider.infoFilePath)
        userInfo.info = info ?? ""
        if let avatarData = try? Data(contentsOf: self.userInfoPathProvider.avatarFilePath) {
            userInfo.avatar = UIImage(data: avatarData)
        }
    }
}
