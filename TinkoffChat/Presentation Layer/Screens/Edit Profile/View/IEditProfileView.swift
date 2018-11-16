//
//  IEditProfileView.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IEditProfileView {
    func setUserInfo(_ userInfo: UserInfo)
    func stopLoading()
    func startLoading()
    func showMessage(for result: Result)
    func setUI(forChangedData isChanged: Bool)
}
