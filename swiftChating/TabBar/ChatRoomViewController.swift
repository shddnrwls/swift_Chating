//
//  ChatRoomViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 5. 7..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var uid : String!
    var chatroom : [ChatModel]! = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uid = Auth.auth().currentUser?.uid
        self.getChatroomsList()

        // Do any additional setup after loading the view.
    }
    func getChatroomsList(){
        Database.database().reference().child("chatroom").queryOrdered(byChild: "users/"+uid).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (datasnapshot) in
            for item in  datasnapshot.children.allObjects as! [DataSnapshot]{
                self.chatroom.removeAll()
                if let chatroomdic = item.value as? [String:AnyObject]{
                    let chatmodel = ChatModel(JSON: chatroomdic)
                    self.chatroom.append(chatmodel!)
                }
            }
            self.tableView.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatroom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatRoomListTableViewCell
        
        var destinationUid : String?
        for item in chatroom[indexPath.row].users {
            if(item.key != self.uid){
                destinationUid = item.key
            }
        }
        Database.database().reference().child("users").child(destinationUid!).observeSingleEvent(of: DataEventType.value) { (datasnapshot) in
            let usermodel = UserModel()
            usermodel.setValuesForKeys(datasnapshot.value as! [String:AnyObject])
            cell.titleLbl.text = usermodel.name
            let url = URL(string: usermodel.profileImageUrl!)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, err) in
                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data!)
                    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
                    cell.profileImage.layer.masksToBounds = true
                }
            }).resume()
            let lastMessage = self.chatroom[indexPath.row].comments.keys.sorted(){$0>$1}
            cell.lastMessageLbl.text = self.chatroom[indexPath.row].comments[lastMessage[0]]?.message
            
        }
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
}
