//
//  PeopleViewController.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 9..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class PeopleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var array : [UserModel] = []
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PeopleViewTableCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.top.equalTo(view)
            m.bottom.left.right.equalTo(view)

        }
        
        
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            self.array.removeAll()
            let myUid = Auth.auth().currentUser?.uid
            
            
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let userModel = UserModel()
                userModel.setValuesForKeys(fchild.value as! [String : Any])
                if(userModel.uid == myUid){
                    continue
                }
                self.array.append(userModel)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        })
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for :indexPath) as! PeopleViewTableCell
        
        
        let imageview = cell.imageview!
        
        imageview.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(cell).offset(10 )
            m.height.width.equalTo(50)
        }
        
        
        URLSession.shared.dataTask(with: URL(string: array[indexPath.row].profileImageUrl!)!) { (data, response, err) in
            
            
            DispatchQueue.main.async {
                imageview.image = UIImage(data: data!)
                imageview.layer.cornerRadius = imageview.frame.size.width/2
                imageview.clipsToBounds = true
            }
            
            }.resume()
        
        let label = cell.label!
        
        label.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(imageview.snp.right).offset(20)
        }
        
        label.text = array[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        view?.destinationUid = self.array[indexPath.row].uid
        self.navigationController?.pushViewController(view!, animated: true)
    }


}
class PeopleViewTableCell :UITableViewCell{
    var imageview: UIImageView! = UIImageView()
    var label :UILabel! = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(imageview)
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
