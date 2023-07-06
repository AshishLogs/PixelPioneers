//
//  LandingVC.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import UIKit

class LandingVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let services : [ServiceType] = [.medical,.invoice,.card,.electricity,.adhar,.logout]
    var currentMode : ServiceType = .electricity
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "ServiceGrid", bundle: nil), forCellWithReuseIdentifier: "ServiceGrid")
        collectionView.backgroundColor = UIColor.init(hex: "252525")
        view.backgroundColor = UIColor.init(hex: "252525")

        let layout = UICollectionViewFlowLayout()
               layout.minimumInteritemSpacing = 0
               layout.minimumLineSpacing = 0
               collectionView.collectionViewLayout = layout
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
    }
    
    func actionOnModeSelection(imageData : String, selectedImage : UIImage) {
        switch self.currentMode {
        case .adhar:
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
        case .card:
            APIClient.uploadCreditCardImage(base64Image: imageData) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.moveToListView(selectedImage, models: model.list, title: "Credit Card", rawData: model.data)
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
                
            }
        case .electricity:
            APIClient.uploadElectrictyImage(base64Image: imageData) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.moveToListView(selectedImage, models: model.list, title: "Electricity Bill", rawData: model.data)
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
            }
        case .invoice:
            APIClient.uploadInvoiceImage(base64Image: imageData) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.moveToListView(selectedImage, models: model.list, title: "Invoice", rawData: model.data)
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
            }
        case .medical:
            APIClient.uploadMedicalDocumentImage(base64Image: imageData) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.moveToListView(selectedImage, models: model.list, title: "Health Document", rawData: model.data)
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        case .logout:
            if let signInVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingVC") as? SignInViewController {
                let nav = UINavigationController.init(rootViewController: signInVC)
                UIApplication.shared.windows.first?.rootViewController = nav
            }
        }
    }
    
}

extension LandingVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceGrid", for: indexPath)
        if let cell = cell as? ServiceGrid {
            cell.contentView.backgroundColor = UIColor.clear
            cell.configureCell(type: services[indexPath.row], title: services[indexPath.row].rawValue)
        }
        // Configure the cell
        return cell
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalItems = collectionView.numberOfItems(inSection: 0)
        let numberOfColumns = (totalItems % 2 == 0) ? 2 : 1 // Use 2 columns for even totalItems, 1 column for odd totalItems
        let width = (collectionView.frame.size.width - 15) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
              title: currentMode.message,
              message: nil,
              actions: [photoLibraryAction, cameraAction, cancelAction],
              completion: nil)
        case .adhar:
            if let registerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KYCPageViewController") as? KYCPageViewController {
                registerVC.isFirstLaunch = false
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
        case .logout:
            if let signInVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
                let nav = UINavigationController.init(rootViewController: signInVC)
                UIApplication.shared.windows.first?.rootViewController = nav
            }
        }
    }
}
    
extension LandingVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = Utility.convertImageToBase64(image: selectedImage){
                actionOnModeSelection(imageData: imageData, selectedImage: selectedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
