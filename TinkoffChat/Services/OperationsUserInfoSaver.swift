//
//  OperationsUserInfoSaver.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class OperationsUserInfoSaver: IUserInfoSaver {
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    private class SaveFileOperation: Operation {
        let url: URL
        let userInfo: UserInfo
        var result: Result = .error
        
        init(url: URL, userInfo: UserInfo) {
            self.url = url
            self.userInfo = userInfo
        }
        
        override func main() {
            do {
                let data = try JSONEncoder().encode(userInfo)
                try data.write(to: url)
                result = .success
            } catch {
                result = .error
            }
        }
    }
    
    func save(_ userInfo: UserInfo, to path: URL, completion: @escaping SaverCompletion) {
        let saveFileOperation = SaveFileOperation(url: path, userInfo: userInfo)
        saveFileOperation.completionBlock = {
            completion(saveFileOperation.result)
        }
        operationQueue.addOperation(saveFileOperation)
        
    }
}
