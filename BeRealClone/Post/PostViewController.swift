//
//  PostViewController.swift
//  BeRealClone
//
//  Created by Leonardo Villalobos on 3/6/23.
//

import UIKit
import PhotosUI
import ParseSwift

class PostViewController: UIViewController {
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var pickedImage: UIImage?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideSpinner()
        previewImageView.isHidden = true
        errorLabel.isHidden = true
    }

    // MARK: IBActions
    @IBAction func onImagePicked(_ sender: Any) {
        var config: PHPickerConfiguration = .init()
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func onCameraPicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            errorLabel.text = "Camera unavailable. Please try again."
            UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                self?.errorLabel.isHidden = false
            }
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func onShareTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            self?.errorLabel.isHidden = true
        }
        
        guard let image = pickedImage,
            let imageData = image.jpegData(compressionQuality: 0.1) else {
            errorLabel.text = "You must select an image to upload!"
            UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                self?.errorLabel.isHidden = false
            }
            return
        }
        
        let imageFile = ParseFile(name: "image.jpg", data: imageData)
        let post: Post = .init(
            caption: captionTextField.text,
            user: User.current,
            imageFile: imageFile
        )
        
        self.showSpinner()
        post.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("Post saved: \(post)")
                    self?.hideSpinner()
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.errorLabel.text = error.localizedDescription
                    UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                        self?.errorLabel.isHidden = false
                    }
                }
            }
        }
    }
    

    @IBAction func onViewTapped(_ sender: Any) {
        view.endEditing(true)
    }

    // MARK: Private helpers
    private func showSpinner() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    private func hideSpinner() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}

// MARK: Conform PostViewController to PHPickerViewControllerDelegate
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            self?.errorLabel.isHidden = true
        }
        
        guard let provider = results.first?.itemProvider,
            provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let image = object as? UIImage else {
                self?.errorLabel.text = "Unable to load image. Please try again."
                UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                    self?.errorLabel.isHidden = false
                }
                return
            }
            if let error = error {
                self?.errorLabel.text = error.localizedDescription
                UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                    self?.errorLabel.isHidden = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.previewImageView.image = image
                self?.pickedImage = image
                self?.previewImageView.isHidden = false
            }
        }
    }
}

// MARK: Conform PostViewController to UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)
        
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            self?.errorLabel.isHidden = true
        }
        
        guard let image = info[.originalImage] as? UIImage else {
            errorLabel.text = "Unable to load the image. Please try again."
            UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                self?.errorLabel.isHidden = false
            }
            return
        }
        
        previewImageView.image = image
        previewImageView.isHidden = false
        pickedImage = image
    }
}
