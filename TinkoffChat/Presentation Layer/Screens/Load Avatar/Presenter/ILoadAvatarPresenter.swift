//
//  ILoadAvatarPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 22/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

protocol ILoadAvatarPresenter: class {
    func setup()
    func getImage(for url: URL, completion: @escaping (LoadedImage) -> Void)
    func selectImage(from url: URL)
}
