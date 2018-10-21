//
//  IUserInfoPathProvider.swift
//  TinkoffChat
//
//  Created by Sofia on 21/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IUserInfoPathProvider {
    var userNameFilePath: URL { get }
    var infoFilePath: URL { get }
    var avatarFilePath: URL { get }
}
