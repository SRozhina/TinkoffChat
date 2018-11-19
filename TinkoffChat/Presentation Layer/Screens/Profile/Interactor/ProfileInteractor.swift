//
//  ProfileInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ProfileInteractor: IProfileInteractor {
    private var userProfileDataChangedService: IUserProfileDataService
    weak var delegate: ProfileInteractorDelegate?
    
    init(userProfileDataChangedService: IUserProfileDataService) {
        self.userProfileDataChangedService = userProfileDataChangedService
    }
    
    func setup() {
        userProfileDataChangedService.setupService()
        userProfileDataChangedService.userDelegate = self
        
        let userInfo = userProfileDataChangedService.getUserProfileInfo()
        delegate?.setUserInfo(userInfo)
    }
}

extension ProfileInteractor: UserProfileDataServiceDelegate {
    func updateUser(with userInfo: UserInfo) {
        delegate?.setUserInfo(userInfo)
    }
}
