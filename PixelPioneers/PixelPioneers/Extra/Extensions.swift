//
//  Extensions.swift
//  PixelPioneers
//
//  Created by Sushant on 05/07/23.
//

import Foundation
import UIKit

extension UIButton {
    func addBorder() {
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
    }
}

extension UIViewController {
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
    
    func showToast(message: String) {
         let toastView = ToastView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
         toastView.center = view.center
         toastView.showMessage(message)
         view.addSubview(toastView)
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             toastView.removeFromSuperview()
         }
     }
    
    func moveToListView(_ selectedImage: UIImage, models: [OCRValues], title: String, rawData: Data?) {
        if let scanner = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OCRScannedListViewController") as? OCRScannedListViewController {
            scanner.titleImage = selectedImage
            scanner.models = models
            scanner.titleName = title
            scanner.rawData = rawData
            if models.count > 0 {
                self.navigationController?.pushViewController(scanner, animated: true)
            } else {
                self.showToast(message: "Sorry. No usable data found from your photo.")
            }
        }
    }
}

extension UIImage {
    
    func resizeByByte(maxByte: Int, completion: @escaping (Data) -> Void) {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count
        
        while imageByte! > maxByte {
            imageData = self.jpegData(compressionQuality: compressQuality)!
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
        }
        
        if maxByte > imageByte! {
            completion(imageData)
        } else {
            completion(self.jpegData(compressionQuality: 1)!)
        }
    }
}

extension UIColor {
    convenience init?(hex: String, alpha : CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
