//
//  UserInfoService.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class UserInfoStorage: IUserInfoStorage {
    private var userInfo: UserInfo?
    private let fileName = "UserInfoFile"
    private let GCDSaver: IUserInfoSaver = GCDUserInfoSaver()
    private let OperationsSaver: IUserInfoSaver = OperationsUserInfoSaver()
    
    func getUserInfo(_ completion: (UserInfo) -> Void) {
        if userInfo == nil,
            let userInfoData = try? Data(contentsOf: getFilePath()) {
            userInfo = try? JSONDecoder().decode(UserInfo.self, from: userInfoData)
        }
        
        completion(userInfo ?? UserInfo(name: "No name"))
    }
    
    func saveUserInfo(_ userInfo: UserInfo, saveOption: SaveOptions, completion: @escaping SaverCompletion) {
        self.userInfo = userInfo
        let saver = getSaver(with: saveOption)
        saver.save(userInfo, to: getFilePath(), completion: completion)
    }
    
    private func getSaver(with saveOption: SaveOptions) -> IUserInfoSaver {
        switch saveOption {
        case .GCD:
            return GCDSaver
        case .Operations:
            return OperationsSaver
        }
    }
    
    private func getFilePath() -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(fileName)
    }
}
