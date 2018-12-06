//
//  AvatarNetworkServiceMock.swift
//  TinkoffChatTests
//
//  Created by Sofia on 06/12/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
@testable import TinkoffChat
import Foundation
import UIKit

class AvatarNetworkServiceMock: IAvatarNetworkService {
    var invokedGetImagesURLs = false
    var invokedGetImagesURLsCount = 0
    var stubbedGetImagesURLsCompletionResult: ([URL], Void)?
    func getImagesURLs(completion: @escaping ([URL]) -> Void) {
        invokedGetImagesURLs = true
        invokedGetImagesURLsCount += 1
        if let result = stubbedGetImagesURLsCompletionResult {
            completion(result.0)
        }
    }
    var invokedGetImage = false
    var invokedGetImageCount = 0
    var invokedGetImageParameters: (url: URL, Void)?
    var invokedGetImageParametersList = [(url: URL, Void)]()
    var stubbedGetImageCompletionResult: (UIImage, Void)?
    func getImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        invokedGetImage = true
        invokedGetImageCount += 1
        invokedGetImageParameters = (url, ())
        invokedGetImageParametersList.append((url, ()))
        if let result = stubbedGetImageCompletionResult {
            completion(result.0)
        }
    }
}
