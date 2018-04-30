//
//  ChatViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 30..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    

    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var sendBtn: UIButton!
    var uid : String?
    var chatRoomUid : String?
    public var destinationUid :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        sendBtn.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func createRoom(){
        let createRoomInfo : Dictionary<String,Any> =  [ "users" : [
                uid!:true,
                destinationUid!:true
            ]
        ]
        if (chatRoomUid == nil){
            Database.database().reference().child("chatroom").childByAutoId().setValue(createRoomInfo)
        }
        else{
            let value : Dictionary<String,Any> = [
                "comments":[
                    "uid": uid!,
                    "message":messageTextfield.text!
                ]
            ]
            Database.database().reference().child("chatroom").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
        
        
    }
    @objc func checkChatRoom(){
        Database.database().reference().child("chatroom").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (datasnapshot) in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                self.chatRoomUid = item.key
                
            }
        }
    }
}
