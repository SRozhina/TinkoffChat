//
//  IUsersDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IUsersDataChangedService {
    func setupService()
    var usersDelegate: UsersDataChangedServiceDelegate? { get set }
}
