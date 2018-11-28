//
//  EditProfileInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class EditProfileInteractor: IEditProfileInteractor {
    private var userProfileDataService: IUserProfileDataService
    weak var delegate: EditProfileInteractorDelegate?
    
    init(userProfileDataService: IUserProfileDataService) {
        self.userProfileDataService = userProfileDataService
    }
    
    func setup() {
        userProfileDataService.setupService()
        userProfileDataService.userDelegate = self
        let userInfo = userProfileDataService.getUserProfileInfo()
        delegate?.setUserInfo(userInfo)
    }
    
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping (Result) -> Void) {
        userProfileDataService.saveUserProfileInfo(userInfo)
        completion(.success)
    }
}

extension EditProfileInteractor: UserProfileDataServiceDelegate {
    func updateUser(with userInfo: UserInfo) {
        delegate?.setUserInfo(userInfo)
    }
}
