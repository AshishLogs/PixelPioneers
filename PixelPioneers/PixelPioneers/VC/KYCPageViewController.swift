//
//  KYCPageViewController.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import UIKit
import AVFoundation

class KYCPageViewController: UIViewController {

    var isFirstLaunch : Bool = true
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageUploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSkip.isHidden = !isFirstLaunch
        // Do any additional setup after loading the view.
    }
    

    
    func changeUploadImageTitle() {
        imageUploadButton.setTitle("Retake Aadhar", for: .normal)
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
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
          title: DocumentType.adhar.message,
          message: nil,
          actions: [photoLibraryAction, cameraAction, cancelAction],
          completion: nil)
    }
    


    
    @IBAction func skipToHomeAction(_ sender: UIButton) {
        if let landingVC = UIStoryboard.init(name: "Journey", bundle: nil).instantiateViewController(withIdentifier: "LandingVC") as? LandingVC {
            let nav = UINavigationController.init(rootViewController: landingVC)
            UIApplication.shared.windows.first?.rootViewController = nav
        }
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
            if let imageData = Utility.convertImageToBase64(image: selectedImage){
                APIClient.uploadAadharImage(base64Image: imageData) { result in
                    switch result {
                    case .success(let model):
                        DispatchQueue.main.async {
                            self.moveToListView(selectedImage, models: model.list, title: "Aadhar Card", rawData: model.data)
                        }
                        
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true)
    }
}

