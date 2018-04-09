//
//  SignUpViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 9..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        // Do any additional setup after loading the view.
    }

    @objc func signupEvent(){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, err) in
            let uid = user?.uid
            let image = UIImageJPEGRepresentation(self.imgView.image!, 0.1)
            Storage.storage().reference().child("userImages").child(uid!).putData(image!, metadata: nil, completion:{ (data,error) in
                let imageUrl = data?.downloadURL()?.absoluteString
                 Database.database().reference().child("users").child(uid!).setValue(["name": self.nameTextField.text!,"porfileImageUrl":imageUrl])
            })
            
        }
        
    }
    @objc func cancelEvent(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgView.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
    }
    


}
