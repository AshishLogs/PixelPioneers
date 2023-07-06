//
//  SignInViewController.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSignIn.addBorder()
        passwordTF.delegate = self
        phoneNumberTF.delegate = self
        phoneNumberTF.text = "9988765643"
        passwordTF.text = "PixelPioneers"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        if (passwordTF.text?.count ?? 0) < 1 || (phoneNumberTF.text?.count ?? 0) < 1 {
            showToast(message: "Please enter both of the details")
            return
        }
        
        if let registerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KYCPageViewController") as? KYCPageViewController {
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
