//
//  IUserInfoService.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

enum StorageType {
    case GCD
    case Operations
}

enum Result {
    case success
    case error
}

typealias SaverCompletion = (Result) -> Void

protocol IUserInfoStorage {
    func getUserInfo(_ completion: @escaping (UserInfo) -> Void)
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping SaverCompletion)
}
