//
//  ChatViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 30..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var bottomContraint: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var sendBtn: UIButton!
    var uid : String?
    var chatRoomUid : String?
    var comments : [ChatModel.Comment] = []
    var userModel : UserModel?
    
    public var destinationUid :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        sendBtn.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
        self.tabBarController?.tabBar.isHidden = true
        
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow(notification:)), name: .UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillshow(notification: Notification){
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            self.bottomContraint.constant = keyboardSize.height
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (complete) in
            
            if self.comments.count > 0{
                self.tableView.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableViewScrollPosition.bottom, animated: true)
                
            }
            
            
        })
        
    }
    @objc func keyboardWillHide(notification: Notification){
        self.bottomContraint.constant = 20
        self.view.layoutIfNeeded()
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    
    
    
    @objc func createRoom(){
        let createRoomInfo : Dictionary<String,Any> =  [ "users" : [
                uid!:true,
                destinationUid!:true
            ]
        ]
        if (chatRoomUid == nil){
            self.sendBtn.isEnabled = false
            Database.database().reference().child("chatroom").childByAutoId().setValue(createRoomInfo) { (err, ref) in
                if(err == nil)
                {
                    self.checkChatRoom()
                }
            }
            
        }
        else{
            let value : Dictionary<String,Any> = [
                
                    "uid": uid!,
                    "message":messageTextfield.text!
                
            ]
            Database.database().reference().child("chatroom").child(chatRoomUid!).child("comments").childByAutoId().setValue(value) { (err, ref) in
                self.messageTextfield.text = ""
            }
        }
        
        
    }
    @objc func checkChatRoom(){
        Database.database().reference().child("chatroom").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (datasnapshot) in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomdic = item.value as? [String:AnyObject]{
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    if(chatModel?.users[self.destinationUid!] == true){
                        self.chatRoomUid = item.key
                        self.sendBtn.isEnabled = true
                        self.getDestinationInfo()
                    }
                }
                
            }
        }
    }
    func getDestinationInfo(){
        Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value) { (datasnapshot) in
            self.userModel = UserModel()
            self.userModel?.setValuesForKeys(datasnapshot.value as! [String:Any])
            self.getMessageList()
        }
    }
    func getMessageList(){
        Database.database().reference().child("chatroom").child(self.chatRoomUid!).child("comments").observe(DataEventType.value) { (datasnapshot) in
            self.comments.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableView.reloadData()
            if self.comments.count > 0{
                self.tableView.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableViewScrollPosition.bottom, animated: true)
                
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.comments[indexPath.row].uid == uid){
            let view = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            view.messagelbl.text = self.comments[indexPath.row].message
            view.messagelbl.numberOfLines = 0
            return view
        }else{
            let view = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
            view.name.text = userModel?.name
            view.messagelbl.text = self.comments[indexPath.row].message
            view.messagelbl.numberOfLines = 0
            let url = URL(string: (self.userModel?.profileImageUrl)!)
            URLSession.shared.dataTask(with: url!) { (data, response, err) in
                DispatchQueue.main.async {
                    view.profileimage.image = UIImage(data: data!)
                    view.profileimage.layer.cornerRadius = view.profileimage.frame.width/2
                    view.profileimage.clipsToBounds = true
                }
            }.resume()
            return view
            
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}

class MyMessageCell :UITableViewCell{
    @IBOutlet var messagelbl: UILabel!
    
}
class DestinationMessageCell :UITableViewCell{
    @IBOutlet var messagelbl: UILabel!
    @IBOutlet var profileimage: UIImageView!
    @IBOutlet var name: UILabel!
    
}
