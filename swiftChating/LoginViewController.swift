//
//  LoginViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 9..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet var siginInBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var password: UITextField!
    let remoteConfig = RemoteConfig.remoteConfig()
    var color : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! Auth.auth().signOut()
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints{ (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        siginInBtn.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewTabBarController") as! UITabBarController
                self.present(view, animated: true, completion: nil)
            }
        }
        
        
    }
    
    @objc func presentSignup(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(view, animated: true, completion: nil)
    }
    @objc func loginEvent(){
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: password.text!){ (user, err) in
            let alert = UIAlertController(title: "에러", message: err.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated: true,completion: nil)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(emailTextfield))
        { password.becomeFirstResponder()
            
        } else if(textField.isEqual(password)) {
            password.resignFirstResponder()
            
        }
        return true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
