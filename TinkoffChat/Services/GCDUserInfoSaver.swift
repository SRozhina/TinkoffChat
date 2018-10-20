//
//  GCDUserInfoSaver.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class GCDUserInfoSaver: IUserInfoSaver {
    func save(_ userInfo: UserInfo, to path: URL, completion: @escaping SaverCompletion) {
        DispatchQueue.main.async {
            self.saveUserInfo(userInfo, to: path, completion: completion)
        }
    }
    
    private func saveUserInfo(_ userInfo: UserInfo, to path: URL, completion: SaverCompletion) {
        do {
            let data = try JSONEncoder().encode(userInfo)
            try data.write(to: path)
            completion(.success)
        } catch {
            completion(.error)
        }
    }
}
