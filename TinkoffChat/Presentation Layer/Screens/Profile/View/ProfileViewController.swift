//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 19/09/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: TinkoffViewController, UINavigationControllerDelegate, IProfileView {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    var presenter: IProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        presenter.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUIElements() {
        avatarImageView.layer.cornerRadius = view.frame.width / 9
        editButton.layer.cornerRadius = 12
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 1
    }
    
    func setUserInfo(_ userInfo: UserInfo) {
        avatarImageView.image = userInfo.avatar
        nameLabel.text = userInfo.name
        descriptionLabel.text = userInfo.info
    }
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        let editProfileStoryboard = UIStoryboard(name: "EditProfileViewController", bundle: nil)
        guard let editProfileViewController = editProfileStoryboard.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
