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
    private let userInfoStorage: IUserInfoStorage
    
    init(view: IProfileView, userInfoStorage: IUserInfoStorage) {
        self.view = view
        self.userInfoStorage = userInfoStorage
    }
    
    func setup() {
        userInfoStorage.getUserInfo { userInfo in
            view.setUserInfo(userInfo)
        }
    }
}
