//
//  IConversationView.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IConversationView: class {
    func setMessages(_ messages: [Message])
    func setTitle(_ title: String?)
    func showErrorAlert(with title: String, retryAction: @escaping () -> Void)
    func startUpdates()
    func endUpdates()
    func updateMessage(at indexPath: IndexPath)
    func insertMessage(at indexPath: IndexPath)
    func deleteMessage(at indexPath: IndexPath)
    var isOnline: Bool { get set }
}
