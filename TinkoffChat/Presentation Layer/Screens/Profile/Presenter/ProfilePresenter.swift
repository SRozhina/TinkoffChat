//
//  ProfilePresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 21/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ProfilePresenter: IProfilePresenter {
    private unowned let view: IProfileView
    private var interactor: IProfileInteractor
    private var userInfo: UserInfo? {
        didSet {
            if let userInfo = userInfo {
                view.setUserInfo(userInfo)
            }
        }
    }
    
    init(view: IProfileView, interactor: IProfileInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func setup() {
        interactor.delegate = self
        interactor.setup()
    }
}

extension ProfilePresenter: ProfileInteractorDelegate {
    func setUserInfo(_ newUserInfo: UserInfo) {
        userInfo = newUserInfo
    }
}
