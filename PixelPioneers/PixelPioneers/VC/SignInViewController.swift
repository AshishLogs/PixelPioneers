//
//  SignInViewController.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        passwordTF.delegate = self
        phoneNumberTF.delegate = self
        phoneNumberTF.text = "9988765643"
        passwordTF.text = "PixelPioneers"
        passwordTF.backgroundColor = UIColor.gray
        phoneNumberTF.backgroundColor = UIColor.gray
        passwordTF.textColor = .white
        phoneNumberTF.textColor = .white
        countryCodeTF.backgroundColor = UIColor.gray
        countryCodeTF.textColor = .white
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5.0
        self.view.backgroundColor = UIColor.init(hex: "252525")
        buttonSignIn.layer.cornerRadius = 10.0
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        if (passwordTF.text?.count ?? 0) < 1 || (phoneNumberTF.text?.count ?? 0) < 1 {
            showToast(message: "Please enter both of the details")
            return
        }
        
        if let landingVC = UIStoryboard.init(name: "Journey", bundle: nil).instantiateViewController(withIdentifier: "LandingVC") as? LandingVC {
            let nav = UINavigationController.init(rootViewController: landingVC)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
