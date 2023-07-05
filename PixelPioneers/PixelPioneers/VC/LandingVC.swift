//
//  LandingVC.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import UIKit

class LandingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let services : [DocumentType] = [.medical,.invoice,.card,.electricity,.adhar]
    var currentMode : DocumentType = .electricity
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
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
    
}

extension LandingVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        if let cell = cell as? ServiceCell {
            cell.configureService(title: services[indexPath.row].rawValue)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentMode = services[indexPath.row]
        switch currentMode {
        case .medical, .invoice, .card, .electricity : 
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
        case .adhar:
            if let registerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KYCPageViewController") as? KYCPageViewController {
                registerVC.isFirstLaunch = false
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
        }
    }
}


extension LandingVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = Utility.convertImageToBase64(image: selectedImage){
                APIClient.uploadAadharImage(base64Image: imageData) { result in
                    switch result {
                    case .success(let model):
                        DispatchQueue.main.async {
                            if let scanner = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OCRScannedListViewController") as? OCRScannedListViewController {
                                scanner.titleImage = selectedImage
                                scanner.models = model.list
                                scanner.titleName = "Aadhar Card"
                                self.navigationController?.pushViewController(scanner, animated: true)
                            }
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
