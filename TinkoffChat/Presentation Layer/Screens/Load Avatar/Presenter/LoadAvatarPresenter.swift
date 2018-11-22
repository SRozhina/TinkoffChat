//
//  LoadAvatarPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 22/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class LoadAvatarPresenter: ILoadAvatarPresenter {
    private let avatarNetworkService: IAvatarNetworkService
    private let view: ILoadAvatarView
    
    init(view: ILoadAvatarView, avatarNetworkService: IAvatarNetworkService) {
        self.view = view
        self.avatarNetworkService = avatarNetworkService
    }
    
    func setup() {
        view.startLoading()
        avatarNetworkService.getImagesURLs {
            self.view.stopLoading()
            self.view.setURLs($0)
        }
    }
    
    func getImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        avatarNetworkService.getImage(from: url) { completion($0) }
    }
}
extension LoadAvatarPresenter: AvatarNetworkServiceDelegate {
    func showError(with text: String) {
        view.showError(with: text)
    }
}
