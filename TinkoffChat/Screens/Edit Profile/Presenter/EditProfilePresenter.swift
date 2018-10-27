//
//  EditProfilePresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import UIKit

class EditProfilePresenter: IEditProfilePresenter {
    private let view: IEditProfileView
    private let userInfoStorageProvider: IUserInfoStorageProvider
    
    private var userInfo: UserInfo!
    
    init(view: IEditProfileView, userInfoStorageProvider: IUserInfoStorageProvider) {
        self.view = view
        self.userInfoStorageProvider = userInfoStorageProvider
    }
    
    func setup() {
        let userInfoStorage = userInfoStorageProvider.getUserInfoStorage(storageType: .GCD)
        userInfoStorage.getUserInfo { fetchedUserInfo in
            self.userInfo = fetchedUserInfo
            self.view.setUserInfo(fetchedUserInfo)
        }
    }
    
    func saveUserInfo(_ newUserInfo: UserInfo, to storageType: StorageType) {
        view.startLoading()
        let userInfoStorage = userInfoStorageProvider.getUserInfoStorage(storageType: storageType)
        userInfoStorage.saveUserInfo(newUserInfo) { result in
            if result == .success {
                self.userInfo = newUserInfo
            }
            self.view.stopLoading()
            self.view.setUI(forChangedData: false)
            self.view.showMessage(for: result)
        }
    }
        
    func userInfoDataChanged(name: String? = nil, info: String? = nil, avatar: UIImage? = nil) {
        view.setUI(forChangedData: userInfo.name != name || userInfo.info != info || userInfo.avatar != avatar)
    }
}