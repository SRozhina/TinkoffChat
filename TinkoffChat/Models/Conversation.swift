//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Sofia on 27/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class Conversation {
    let user: Peer
    var messages: [Message]
    var isOnline: Bool
    
    init(user: Peer, messages: [Message] = [], isOnline: Bool = true) {
        self.user = user
        self.messages = messages
        self.isOnline = isOnline
    }
}
