//
//  LoginViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 9..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet var siginInBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    let remoteConfig = RemoteConfig.remoteConfig()
    var color : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints{ (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        siginInBtn.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
        
        
    }
    
    @objc func presentSignup(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(view, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
