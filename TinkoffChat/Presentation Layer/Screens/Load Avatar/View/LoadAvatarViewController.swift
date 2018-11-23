//
//  LoadAvatarViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 22/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import UIKit

class LoadAvatarViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var imageURLs: [URL] = []
    var presenter: ILoadAvatarPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        presenter.setup()
    }

    private func registerNibs() {
        collectionView.register(UINib(nibName: String(describing: AvatarCell.self), bundle: nil),
                                forCellWithReuseIdentifier: String(describing: AvatarCell.self))
    }
}

extension LoadAvatarViewController: ILoadAvatarView {
    func setImageURLs(_ imageURLs: [URL]) {
        self.imageURLs = imageURLs
        collectionView.reloadData()
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError(with text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension LoadAvatarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        
        presenter.selectImage(from: imageURLs[indexPath.row])
    }
}

extension LoadAvatarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AvatarCell.self), for: indexPath) as! AvatarCell
        
        let url = imageURLs[indexPath.row]
        cell.startLoading(from: url)
        presenter.getImage(for: url) { cell.setImage($0) }
        
        return cell
    }
}

extension LoadAvatarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (view.bounds.width - 40) / 3
        return CGSize(width: side, height: side)
    }
}
