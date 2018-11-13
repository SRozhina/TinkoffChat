//
//  MessagesDataChangedServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol MessagesDataChangedServiceDelegate: BaseDataChangedServiceDelegate {
    func updateMessage(at indexPath: IndexPath)
    func insertMessage(at indexPath: IndexPath)
    func deleteMessage(at indexPath: IndexPath)
}
