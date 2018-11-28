//
//  ProfileInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ProfileInteractor: IProfileInteractor {
    private var userProfileDataService: IUserProfileDataService
    weak var delegate: ProfileInteractorDelegate?
    
    init(userProfileDataService: IUserProfileDataService) {
        self.userProfileDataService = userProfileDataService
    }
    
    func setup() {
        userProfileDataService.setupService()
        userProfileDataService.userDelegate = self
        
        let userInfo = userProfileDataService.getUserProfileInfo()
        delegate?.setUserInfo(userInfo)
    }
}

extension ProfileInteractor: UserProfileDataServiceDelegate {
    func updateUser(with userInfo: UserInfo) {
        delegate?.setUserInfo(userInfo)
    }
}
