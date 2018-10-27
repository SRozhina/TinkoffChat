//
//  UserInfoService.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import UIKit

class GCDUserInfoStorage: IUserInfoStorage {
    private let userInfoPathProvider: IUserInfoPathProvider
    
    init(userInfoPathProvider: IUserInfoPathProvider) {
        self.userInfoPathProvider = userInfoPathProvider
    }
    
    func getUserInfo(_ completion: @escaping (UserInfo) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let name = (try? String(contentsOf: self.userInfoPathProvider.userNameFilePath)) ?? "No name"
            let info = (try? String(contentsOf: self.userInfoPathProvider.infoFilePath)) ?? ""
            let avatarData = try? Data(contentsOf: self.userInfoPathProvider.avatarFilePath)
            let avatar = avatarData != nil ? UIImage(data: avatarData!) : UIImage(named: "avatar_placeholder")
            let userInfo = UserInfo(name: name, info: info, avatar: avatar)
            DispatchQueue.main.async {
                completion(userInfo)
            }
        }
    }
    
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping SaverCompletion) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.getUserInfo { previousUserInfo in
                do {
                    try self.compareAndSave(userInfo: userInfo,
                                            previousUserInfo: previousUserInfo,
                                            completion: completion)
                } catch {
                    DispatchQueue.main.async {
                        completion(.error)
                    }
                }
            }
        }
    }
    
    private func compareAndSave(userInfo: UserInfo, previousUserInfo: UserInfo, completion: @escaping SaverCompletion) throws {
        if previousUserInfo.name != userInfo.name {
            try userInfo.name.write(to: self.userInfoPathProvider.userNameFilePath, atomically: false, encoding: .utf8)
        }
        if previousUserInfo.info != userInfo.info {
            try userInfo.info.write(to: self.userInfoPathProvider.infoFilePath, atomically: false, encoding: .utf8)
        }
        if previousUserInfo.avatar != userInfo.avatar {
            if let image = userInfo.avatar,
                let imageData = UIImageJPEGRepresentation(image, 1) {
                try imageData.write(to: self.userInfoPathProvider.avatarFilePath)
            }
        }
        DispatchQueue.main.async {
            completion(.success)
        }
    }
}
