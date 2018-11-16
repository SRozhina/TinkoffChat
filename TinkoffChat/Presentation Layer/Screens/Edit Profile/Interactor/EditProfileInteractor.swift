//
//  EditProfileInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class EditProfileInteractor: IEditProfileInteractor {
    private var userProfileDataChangedService: IUserProfileDataService
    weak var delegate: EditProfileInteractorDelegate?
    
    init(userProfileDataChangedService: IUserProfileDataService) {
        self.userProfileDataChangedService = userProfileDataChangedService
    }
    
    func setup() {
        userProfileDataChangedService.setupService()
        userProfileDataChangedService.userDelegate = self
        if let userInfo = userProfileDataChangedService.getUserProfileInfo() {
            delegate?.setUserInfo(userInfo)
        }
    }
    
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping (Result) -> Void) {
        userProfileDataChangedService.saveUserProfileInfo(userInfo)
        completion(.success)
    }
}

extension EditProfileInteractor: UserProfileDataServiceDelegate {
    func updateUser(with userInfo: UserInfo) {
        delegate?.setUserInfo(userInfo)
    }
}
