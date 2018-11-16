//
//  IMessagesStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 16/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IMessagesStorage {
    func setAllMessagesAsRead(in conversationId: String)
    func appendMessage(_ message: Message, to conversationId: String)
}
