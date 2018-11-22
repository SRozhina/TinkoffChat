//
//  AvatarCell.swift
//  TinkoffChat
//
//  Created by Sofia on 22/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func setImage(_ image: UIImage) {
        activityIndicator.stopAnimating()
        imageView.image = image
    }
}
