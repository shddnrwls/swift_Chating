//
//  ChatRoomListTableViewCell.swift
//  swiftChating
//
//  Created by mac on 2018. 5. 7..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit

class ChatRoomListTableViewCell: UITableViewCell {

    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var lastMessageLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
