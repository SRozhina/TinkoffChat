//
//  UserInfoPathProvider.swift
//  TinkoffChat
//
//  Created by Sofia on 21/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class UserInfoPathProvider: IUserInfoPathProvider {
    var userNameFilePath: URL {
        return getFilePath("UserInfoName")
    }
    
    var infoFilePath: URL {
        return getFilePath("UserInfoInfo")
    }
    
    var avatarFilePath: URL {
        return getFilePath("UserInfoAvatar")
    }
    
    var storeFilePath: URL {
        return getFilePath("TinkoffChat.sqlite")
    }
    
    private func getFilePath(_ fileName: String) -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(fileName)
    }
}
