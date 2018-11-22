//
//  IAvatarNetworkService.swift
//  TinkoffChat
//
//  Created by Sofia on 22/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

protocol IAvatarNetworkService {
    func getImagesURLs(completion: @escaping ([URL]) -> Void)
    func getImage(from url: URL, completion: @escaping (UIImage) -> Void)
}
