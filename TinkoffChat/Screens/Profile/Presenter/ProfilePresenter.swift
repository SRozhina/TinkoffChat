//
//  ProfilePresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 21/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ProfilePresenter: IProfilePresenter {
    private let view: IProfileView
    private let userInfoStorageProvider: IUserInfoStorageProvider
    
    init(view: IProfileView, userInfoStorageProvider: IUserInfoStorageProvider) {
        self.view = view
        self.userInfoStorageProvider = userInfoStorageProvider
    }
    
    func setup() {
        let userInfoStorage = userInfoStorageProvider.getUserInfoStorage(storageType: .Default)
        userInfoStorage.getUserInfo { userInfo in
            self.view.setUserInfo(userInfo)
        }
    }
}
