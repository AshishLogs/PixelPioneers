//
//  KYCPageViewController.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import UIKit
import AVFoundation

class KYCPageViewController: UIViewController {

    @IBOutlet weak var userAdharLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var buttonActionViews: UIStackView!
    @IBOutlet weak var buttonInvalidate: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var buttonValidate: UIButton!
    @IBOutlet weak var imageUploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    func initialSetup() {
        userMessageLabel.isHidden = true
        userNameLabel.isHidden = true
        userAdharLabel.isHidden = true
        buttonActionViews.isHidden = true
        buttonValidate.addBorder()
        buttonInvalidate.addBorder()
    }
    
    func setupViewWhenImageIsUploading() {
        userMessageLabel.text = "Please wait while image is getting uploaded"
        userMessageLabel.isHidden = false
    }
    
    func setupViewPostUpload() {
        userMessageLabel.isHidden = false
        userNameLabel.isHidden = false
        userAdharLabel.isHidden = false
        buttonActionViews.isHidden = false
    }
    
    @IBAction func actionValidate(_ sender: UIButton) {
        
    }
    
    @IBAction func actionInvalidate(_ sender: UIButton) {
        initialSetup()
    }
    
    func changeUploadImageTitle() {
        imageUploadButton.setTitle("Retake Aadhar", for: .normal)
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        setupViewWhenImageIsUploading()
        let photoLibraryAction = UIAlertAction(title: "Choose From Library", style: .default) { [weak self] _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.modalPresentationStyle = .overFullScreen
            self?.present(imagePickerController, animated: true)
        }

        let cameraAction = UIAlertAction(title: "Take From Camera", style: .default) { [weak self] _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.modalPresentationStyle = .overFullScreen
            self?.present(imagePickerController, animated: true)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        showAlert(
          style: .actionSheet,
          title: "Choose Your Image",
          message: nil,
          actions: [photoLibraryAction, cameraAction, cancelAction],
          completion: nil)
    }
    
    func showAlert(
      style: UIAlertController.Style,
      title: String?,
      message: String?,
      actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)],
      completion: (() -> Swift.Void)? = nil)
    {
      let alert = UIAlertController(title: title, message: message, preferredStyle: style)
      for action in actions {
        alert.addAction(action)
      }
        self.present(alert, animated: true, completion: completion)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension KYCPageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            changeUploadImageTitle()
            setupViewPostUpload()
            if let imageData = Utility.convertImageToBase64(image: selectedImage){
                APIClient.uploadImage(base64Image: imageData) { result in
                    switch result {
                    case .success(let success):
                        print(success.toDictionary())
                        print(String.init(data: success, encoding: .utf8))
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        userMessageLabel.text = "Please validate Name and Aadhar Number"
        picker.dismiss(animated: true)
    }
}
