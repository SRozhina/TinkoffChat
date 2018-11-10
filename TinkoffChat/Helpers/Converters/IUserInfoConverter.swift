//
//  IUserInfoConverter.swift
//  TinkoffChat
//
//  Created by Sofia on 09/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import UIKit

protocol IUserInfoConverter {
    func makeUserInfo(from userInfoEntity: UserInfoEntity?) -> UserInfo
    func getAvatarPath(for image: UIImage?) -> URL
}

class UserInfoConverter: IUserInfoConverter {
    private let userInfoPathProvider: IUserInfoPathProvider
    
    init(userInfoPathProvider: IUserInfoPathProvider) {
        self.userInfoPathProvider = userInfoPathProvider
    }
    
    func makeUserInfo(from userInfoEntity: UserInfoEntity?) -> UserInfo {
        let name = userInfoEntity?.name ?? "No name"
        let info = userInfoEntity?.info ?? ""
        let avatarData = try? Data(contentsOf: self.userInfoPathProvider.avatarFilePath)
        let avatar = avatarData != nil ? UIImage(data: avatarData!) : UIImage(named: "avatar_placeholder")
        return UserInfo(name: name, info: info, avatar: avatar)
    }
    
    func getAvatarPath(for image: UIImage?) -> URL {
        if let image = image,
           let imageData = UIImageJPEGRepresentation(image, 1) {
            try? imageData.write(to: self.userInfoPathProvider.avatarFilePath)
        }
        return userInfoPathProvider.avatarFilePath
    }
}
