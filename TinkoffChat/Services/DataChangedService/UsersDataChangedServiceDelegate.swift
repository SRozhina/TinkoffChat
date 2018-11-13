//
//  UsersDataChangedServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol UsersDataChangedServiceDelegate: BaseDataChangedServiceDelegate {
    func updateUser(with name: String?, at indexPath: IndexPath)
    func insertUser(at indexPath: IndexPath)
    func deleteUser(at indexPath: IndexPath)
    func moveUser(with name: String?, from indexPath: IndexPath, to newIndexPath: IndexPath)
}
