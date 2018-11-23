//
//  ILoadAvatarView.swift
//  TinkoffChat
//
//  Created by Sofia on 22/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol ILoadAvatarView {
    func setImageURLs(_ images: [URL])
    func showError(with text: String)
    func startLoading()
    func stopLoading()
    func dismiss()
}
