//
//  LoadAvatarViewMock.swift
//  TinkoffChatTests
//
//  Created by Sofia on 06/12/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
@testable import TinkoffChat
import Foundation

class LoadAvatarViewMock: ILoadAvatarView {
    var invokedSetImageURLs = false
    var invokedSetImageURLsCount = 0
    var invokedSetImageURLsParameters: (images: [URL], Void)?
    var invokedSetImageURLsParametersList = [(images: [URL], Void)]()
    func setImageURLs(_ images: [URL]) {
        invokedSetImageURLs = true
        invokedSetImageURLsCount += 1
        invokedSetImageURLsParameters = (images, ())
        invokedSetImageURLsParametersList.append((images, ()))
    }
    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (text: String, Void)?
    var invokedShowErrorParametersList = [(text: String, Void)]()
    func showError(with text: String) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (text, ())
        invokedShowErrorParametersList.append((text, ()))
    }
    var invokedStartLoading = false
    var invokedStartLoadingCount = 0
    func startLoading() {
        invokedStartLoading = true
        invokedStartLoadingCount += 1
    }
    var invokedStopLoading = false
    var invokedStopLoadingCount = 0
    func stopLoading() {
        invokedStopLoading = true
        invokedStopLoadingCount += 1
    }
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
}
