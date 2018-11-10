//
//  Post.swift
//  InstagramTraining
//
//  Created by Keith Cao on 22/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import Foundation

struct Post {
    
    var id: String?
    let imageUrl: String?
    let postDate: Date?
    let user: User
    let caption: String?
    
    var hasLike: Bool = true
    
    init(user: User,dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String
        self.caption = dictionary["PostText"] as? String
        self.user = user
        
        let secondsFrom1970 = dictionary["postDate"] as? Double ?? 0
        self.postDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
}
