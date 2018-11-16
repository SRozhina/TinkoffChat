//
//  IEditProfileInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IEditProfileInteractor {
    func setup()
    func saveUserInfo(_ userInfo: UserInfo, completion: @escaping (Result) -> Void)
}
