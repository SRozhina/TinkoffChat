//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 19/09/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var chooseAvatarButton: UIButton!
    
    private let avatarFileName = "tinkoffChatAvatar.png"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print("Edit button frame in init \(editButton.frame)")
        //app crashes because view doesn't exist yet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        setupProfileData()
        navigationItem.largeTitleDisplayMode = .never
        print("Edit button frame in viewDidLoad \(editButton.frame)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Edit button frame in viewDidAppear \(editButton.frame)")
        //viewDidLoad happens before autolayout is completed. So the position is not yet set by autolayout that was specified in storyboard
    }
    
    private func setupUIElements() {
        avatarImageView.layer.cornerRadius = view.frame.width / 9
        chooseAvatarButton.layer.cornerRadius = view.frame.width / 9
        editButton.layer.cornerRadius = 12
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 1
    }
    
    private func setupProfileData() {
        if let image = getAvatar() {
            avatarImageView.image = image
        }
        nameLabel.text = "Alex Zverev"
        descriptionLabel.text = "Love ❤️ iOS Development, like butterflies, and live in Tinkoff Bank."
    }
    
    @IBAction private func chooseAvatarButtonTapped(_ sender: UIButton) {
        let takePhotoAlertAction = UIAlertAction(title: "Take photo", style: .default) { _ in self.takePhotoAction() }
        let chooseFromLibraryAlertAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.showImagePickerController(with: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        showAlert(with: "Select avatar",
                  message: nil,
                  style: .actionSheet,
                  actions: [takePhotoAlertAction, chooseFromLibraryAlertAction, cancelAction])
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func takePhotoAction() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) { return }

        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            showImagePickerController(with: .camera)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.showImagePickerController(with: .camera)
                } else {
                    self.showCameraAccessErrorAlert()
                }
            }
        }
    }
    
    private func showImagePickerController(with sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true)
    }
    
    private func showCameraAccessErrorAlert() {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        showAlert(with: "No access to camera",
                  message: "You could give the app access to camera in Privacy settings",
                  style: .alert,
                  actions: [okAction])
    }
    
    private func saveAvatar(_ image: UIImage) {
        if let data = UIImageJPEGRepresentation(image, 1) {
            let filePaht = getFilePath()
            try? data.write(to: filePaht)
        }
    }
    
    private func getAvatar() -> UIImage? {
        let filename = getFilePath()
        guard let data = try? Data(contentsOf: filename) else { return nil }
        return UIImage(data: data)
    }
    
    private func getFilePath() -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(avatarFileName)
    }
    
    private func showAlert(with title: String,
                           message: String?,
                           style: UIAlertControllerStyle,
                           actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        avatarImageView.image = image
        saveAvatar(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
