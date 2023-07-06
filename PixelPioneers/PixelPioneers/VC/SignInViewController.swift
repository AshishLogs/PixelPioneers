//
//  SignInViewController.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSignIn.addBorder()
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

}
