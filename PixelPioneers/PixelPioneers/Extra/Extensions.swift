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
}
