//
//  IConversationView.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IConversationView {
    func setMessages(_ messages: [Message])
    func setTitle(_ title: String?)
}
