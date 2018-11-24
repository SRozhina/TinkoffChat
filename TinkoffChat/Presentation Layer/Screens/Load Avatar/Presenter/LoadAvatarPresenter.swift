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
    private let userProfileDataService: IUserProfileDataService
    private var images: [LoadedImage] = [] {
        didSet {
            view.setImageURLs(images.map { $0.url })
        }
    }
    private unowned let view: ILoadAvatarView

    private var userInfo: UserInfo?
    private let batchSize = 30
    
    init(view: ILoadAvatarView, avatarNetworkService: IAvatarNetworkService, userProfileDataService: IUserProfileDataService) {
        self.view = view
        self.avatarNetworkService = avatarNetworkService
        self.userProfileDataService = userProfileDataService
    }
    
    func setup() {
        userProfileDataService.setupService()
        userInfo = userProfileDataService.getUserProfileInfo()
        view.startLoading()
        avatarNetworkService.getImagesURLs {
            self.view.stopLoading()
            self.images = $0.map { LoadedImage(url: $0) }
        }
    }
    
    func getImage(for url: URL, completion: @escaping (LoadedImage) -> Void) {
        guard let loadedImage = images.filter({ $0.url == url }).first else { return }
        if loadedImage.image != nil {
            completion(loadedImage)
            return
        }
        avatarNetworkService.getImage (from: url) {
            loadedImage.image = $0
            completion(loadedImage)
        }
    }
    
    func selectImage(from url: URL) {
        guard let loadedImage = images.filter({ $0.url == url }).first else { return }
        guard let userInfo = userInfo else { return }
        view.startLoading()
        userInfo.avatar = loadedImage.image
        userProfileDataService.saveUserProfileInfo(userInfo)
        view.dismiss()
    }
}

extension LoadAvatarPresenter: AvatarNetworkServiceDelegate {
    func showError(with text: String) {
        view.showError(with: text)
    }
}
