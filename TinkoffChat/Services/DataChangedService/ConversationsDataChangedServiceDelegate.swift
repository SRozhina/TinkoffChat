//
//  ConversationsDataChangedServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol ConversationsDataChangedServiceDelegate: BaseDataChangedServiceDelegate {
    func updateConversation(in section: Int)
    func updateConversations()
}
