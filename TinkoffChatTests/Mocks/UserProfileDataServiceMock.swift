//
//  UserProfileDataServiceMock.swift
//  TinkoffChatTests
//
//  Created by Sofia on 06/12/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
@testable import TinkoffChat
import Foundation

class UserProfileDataServiceMock: IUserProfileDataService {
    var invokedUserDelegateSetter = false
    var invokedUserDelegateSetterCount = 0
    weak var invokedUserDelegate: UserProfileDataServiceDelegate?
    var invokedUserDelegateList = [UserProfileDataServiceDelegate?]()
    var invokedUserDelegateGetter = false
    var invokedUserDelegateGetterCount = 0
    weak var stubbedUserDelegate: UserProfileDataServiceDelegate!
    var userDelegate: UserProfileDataServiceDelegate? {
        set {
            invokedUserDelegateSetter = true
            invokedUserDelegateSetterCount += 1
            invokedUserDelegate = newValue
            invokedUserDelegateList.append(newValue)
        }
        get {
            invokedUserDelegateGetter = true
            invokedUserDelegateGetterCount += 1
            return stubbedUserDelegate
        }
    }
    var invokedSetupService = false
    var invokedSetupServiceCount = 0
    func setupService() {
        invokedSetupService = true
        invokedSetupServiceCount += 1
    }
    var invokedGetUserProfileInfo = false
    var invokedGetUserProfileInfoCount = 0
    var stubbedGetUserProfileInfoResult: UserInfo!
    func getUserProfileInfo() -> UserInfo {
        invokedGetUserProfileInfo = true
        invokedGetUserProfileInfoCount += 1
        return stubbedGetUserProfileInfoResult
    }
    var invokedSaveUserProfileInfo = false
    var invokedSaveUserProfileInfoCount = 0
    var invokedSaveUserProfileInfoParameters: (userInfo: UserInfo, Void)?
    var invokedSaveUserProfileInfoParametersList = [(userInfo: UserInfo, Void)]()
    func saveUserProfileInfo(_ userInfo: UserInfo) {
        invokedSaveUserProfileInfo = true
        invokedSaveUserProfileInfoCount += 1
        invokedSaveUserProfileInfoParameters = (userInfo, ())
        invokedSaveUserProfileInfoParametersList.append((userInfo, ()))
    }
}
