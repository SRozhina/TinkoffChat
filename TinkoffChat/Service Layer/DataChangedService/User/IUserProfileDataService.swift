//
//  IUserProfileDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 16/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IUserProfileDataService {
    func setupService()
    func getUserProfileInfo() -> UserInfo?
    func saveUserProfileInfo(_ userInfo: UserInfo)
    var userDelegate: UserProfileDataServiceDelegate? { get set }
}
