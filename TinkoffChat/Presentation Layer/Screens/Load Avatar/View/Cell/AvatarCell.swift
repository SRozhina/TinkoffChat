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
    private let placeholderImageName = "loadAvatarPlaceholder"
    private var url: URL?
    
    func startLoading(from url: URL) {
        self.url = url
        imageView.image = UIImage(named: placeholderImageName)
        activityIndicator.startAnimating()
    }
    
    func setImage(_ loadedImage: LoadedImage) {
        if loadedImage.url != url { return }
        activityIndicator.stopAnimating()
        imageView.image = loadedImage.image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = UIImage(named: placeholderImageName)
    }
}
