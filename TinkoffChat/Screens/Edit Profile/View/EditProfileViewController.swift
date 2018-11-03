//
//  EditProfileViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit
import AVFoundation

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var editAvatarButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var infoTextView: UITextView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var saveButtons: [UIButton]!
    private var lastSelectedSaver: StorageType = .GCD
    
    var presenter: IEditProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addDismissKeyboardGestureRecognizer()
        infoTextView.delegate = self
        presenter.setup()
    }
    
    private func setSetButtons(enabled: Bool) {
        for button in saveButtons {
            button.isEnabled = enabled
            button.setTitleColor(enabled ? .black : .lightGray, for: .normal)
        }
    }
    
    private func setupUI() {
        avatarImageView.layer.cornerRadius = view.frame.width / 15
        editAvatarButton.layer.cornerRadius = view.frame.width / 15
        infoTextView.layer.cornerRadius = 6
        setSetButtons(enabled: false)
    }
    
    private func addDismissKeyboardGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        infoTextView.resignFirstResponder()
        userNameTextField.resignFirstResponder()
    }

    @IBAction private func editAvatarTapped(_ sender: UIButton) {
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
    
    @IBAction private func saveViaGCD(_ sender: UIButton) {
        lastSelectedSaver = .GCD
        saveUserInfo()
    }
    
    @IBAction private func saveViaOperations(_ sender: UIButton) {
        lastSelectedSaver = .Operations
        saveUserInfo()
    }
    
    @IBAction func save(_ sender: Any) {
        lastSelectedSaver = .Default
        saveUserInfo()
    }
    
    
    @IBAction private func userNameEdited(_ sender: UITextField) {
        presenter.userInfoDataChanged(name: sender.text, info: infoTextView.text, avatar: avatarImageView.image)
    }
    
    private func saveUserInfo() {
        let name = userNameTextField.text ?? ""
        let info = infoTextView.text ?? ""
        let avatar = avatarImageView.image
        let userInfo = UserInfo(name: name, info: info, avatar: avatar)
        presenter.saveUserInfo(userInfo, to: lastSelectedSaver)
    }
}

extension EditProfileViewController: IEditProfileView {
    func setUserInfo(_ userInfo: UserInfo) {
        userNameTextField.text = userInfo.name
        infoTextView.text = userInfo.info
        guard let avatar = userInfo.avatar else { return }
        avatarImageView.image = avatar
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        setSetButtons(enabled: true)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        setSetButtons(enabled: false)
    }
    
    func setUI(forChangedData isChanged: Bool) {
        setSetButtons(enabled: isChanged)
    }
    
    func showMessage(for result: Result) {
        let title = result == .success ? "Данные сохранены" : "Ошибка"
        let message = result == .success ? nil : "Не удалось сохранить данные"
        var actions: [UIAlertAction] = []
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        actions.append(okAction)
        
        if result == .error {
            let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                self.saveUserInfo()
            }
            actions.append(retryAction)
        }
        
        showAlert(with: title,
                  message: message,
                  style: .alert,
                  actions: actions)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        avatarImageView.image = image
        presenter.userInfoDataChanged(name: userNameTextField.text, info: infoTextView.text, avatar: avatarImageView.image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.userInfoDataChanged(name: userNameTextField.text, info: infoTextView.text, avatar: avatarImageView.image)
    }
}
