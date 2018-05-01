//
//  ChatModel.swift
//  swiftChating
//
//  Created by mac on 2018. 4. 30..
//  Copyright © 2018년 swift. All rights reserved.
//


import ObjectMapper
class ChatModel: Mappable {
   
    
    public var users : Dictionary<String,Bool> = [:]
    public var comments : Dictionary<String,Comment> = [:]
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    
    public class Comment :Mappable{
      
        
        public var uid : String?
        public var message : String?
        public required init?(map: Map) {
            
        }
        
        public func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
        }
    }
}
