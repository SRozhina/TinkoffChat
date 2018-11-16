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
    private let interactor: IProfileInteractor
    private var userInfo: UserInfo! {
        didSet {
            view.setUserInfo(userInfo)
        }
    }
    
    init(view: IProfileView, interactor: IProfileInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func setup() {
        interactor.setup()
    }
}

extension ProfilePresenter: ProfileInteractorDelegate {
    func setUserInfo(_ newUserInfo: UserInfo) {
        userInfo = newUserInfo
    }
}
