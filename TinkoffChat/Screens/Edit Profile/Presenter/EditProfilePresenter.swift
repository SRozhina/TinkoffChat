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
    private let userInfoStorage: IUserInfoStorage
    
    private var userInfo: UserInfo!
    
    init(view: IEditProfileView, userInfoService: IUserInfoStorage) {
        self.view = view
        self.userInfoStorage = userInfoService
    }
    
    func setup() {
        userInfoStorage.getUserInfo { fetchedUserInfo in
            self.userInfo = fetchedUserInfo
            view.setUserInfo(fetchedUserInfo)
        }
    }
    
    func saveUserInfo(_ newUserInfo: UserInfo, to saveOption: SaveOptions) {
        view.startLoading()
        userInfoStorage.saveUserInfo(newUserInfo, saveOption: saveOption) { result in
            if result == .success {
                self.userInfo = newUserInfo
            }
            DispatchQueue.main.async {
                self.view.stopLoading()
                self.view.showMessage(for: result)
            }
        }
    }
    
    func userInfoDataChanged(name: String? = nil, info: String? = nil, avatar: UIImage? = nil) {
        view.setUI(forChangedData: userInfo.name != name || userInfo.info != info || userInfo.avatar != avatar)
    }
}
