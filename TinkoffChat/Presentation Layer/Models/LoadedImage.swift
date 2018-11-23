//
//  LoadedImage.swift
//  TinkoffChat
//
//  Created by Sofia on 23/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class LoadedImage {
    let url: URL
    var image: UIImage?
    
    init(url: URL, image: UIImage? = nil) {
        self.url = url
        self.image = image
    }
}
