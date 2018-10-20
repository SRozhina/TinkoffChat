//
//  IUserInfoSaver.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IUserInfoSaver {
    func save(_ userInfo: UserInfo, to path: URL, completion: @escaping SaverCompletion)
}
