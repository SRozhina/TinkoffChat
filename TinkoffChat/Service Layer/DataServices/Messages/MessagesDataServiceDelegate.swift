//
//  MessagesDataServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol MessagesDataServiceDelegate: BaseDataServiceDelegate {
    func insertMessage(_ message: Message, at indexPath: IndexPath)
}
