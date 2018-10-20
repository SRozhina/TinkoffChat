//
//  IUserInfoService.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

enum SaveOptions {
    case GCD
    case Operations
}

enum Result {
    case success
    case error
}

typealias SaverCompletion = (Result) -> Void

protocol IUserInfoStorage {
    func getUserInfo(_ completion: (UserInfo) -> Void)
    func saveUserInfo(_ userInfo: UserInfo, saveOption: SaveOptions, completion: @escaping SaverCompletion)
}
