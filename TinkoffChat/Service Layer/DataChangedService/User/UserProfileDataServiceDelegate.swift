//
//  UserProfileDataChangedServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 16/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol UserProfileDataServiceDelegate: class {
    func updateUser(with userInfo: UserInfo)
}
