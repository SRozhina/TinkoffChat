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
    private unowned let view: IEditProfileView
    private var interactor: IEditProfileInteractor
    
    private var userInfo: UserInfo? {
        didSet {
            if let userInfo = userInfo {
                view.setUserInfo(userInfo)
            }
        }
    }
    
    init(view: IEditProfileView, interactor: IEditProfileInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func setup() {
        interactor.delegate = self
        interactor.setup()
    }
    
    func saveUserInfo(_ newUserInfo: UserInfo, to storageType: StorageType) {
        view.startLoading()
        interactor.saveUserInfo(newUserInfo) { result in
            self.view.showMessage(for: result)
        }
        view.stopLoading()
        view.setUI(forChangedData: false)
    }
        
    func userProfileInfoDataChanged(name: String? = nil, info: String? = nil, avatar: UIImage? = nil) {
        view.setUI(forChangedData: userInfo?.name != name || userInfo?.info != info || userInfo?.avatar != avatar)
    }
}

extension EditProfilePresenter: EditProfileInteractorDelegate {
    func setUserInfo(_ newUserInfo: UserInfo) {
        userInfo = newUserInfo
    }
}
