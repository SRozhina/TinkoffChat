//
//  IEditProfilePresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

protocol IEditProfilePresenter: class {
    func setup()
    func saveUserInfo(_ userInfo: UserInfo, to saveOption: StorageType)
    func userProfileInfoDataChanged(name: String?, info: String?, avatar: UIImage?)
}
