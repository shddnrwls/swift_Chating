//
//  SignUpViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 9..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func signupEvent(){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, err) in
            let uid = user?.uid
            Database.database().reference().child("users").child(uid!).setValue(["name": self.nameTextField.text!])
        }
        
    }
    @objc func cancelEvent(){
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
