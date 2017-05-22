//
//  ViewController.swift
//  MyChatApp
//
//  Created by ardMac on 09/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    


    @IBOutlet weak var profileImageView: UIImageView!
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
        //var messagesController: MessagesViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectorProfileImageView)))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    }
                })
            }
            
        })
    }
    
    func registerUserIntoDatabaseWithUID(uid : String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            let user = User()
            // This setter potentially crashes if keys don't match
            user.setValuesForKeys(values)
            //self.messagesController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        handleRegister()
        
        let currentStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        if let targetViewController = currentStoryboard .instantiateViewController(withIdentifier: "MessagesViewController") as? MessagesViewController {
            navigationController?.pushViewController(targetViewController, animated: true)
        }
    }
    


    @IBAction func loginButtonTapped(_ sender: Any) {
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
}
    
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectorProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
}



