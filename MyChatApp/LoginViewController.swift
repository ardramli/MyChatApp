//
//  LoginViewController.swift
//  MyChatApp
//
//  Created by ardMac on 10/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var messagesController: MessagesViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let currentUser = FIRAuth.auth()?.currentUser {
//            print("Some user have logged in")
//        }
        // Do any additional setup after loading the view.
    }

    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            // Successfullu logged in our user
            //self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            //self.dismiss(animated: true, completion: nil)
        })
    }

    @IBAction func logInButtonTapped(_ sender: Any) {
        
        handleLogin()
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") {
            navigationController?.pushViewController(signUpVC, animated: true)
        }

    }
}
