//
//  ChatModel.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 30..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit

class ChatModel: NSObject {
    public var users : Dictionary<String,Bool> = [:]
    public var comments : Dictionary<String,Comment> = [:]
    
    public class Comment {
        public var uid : String?
        public var message : String?
    }
}
