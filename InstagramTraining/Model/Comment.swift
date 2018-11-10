//
//  Comment.swift
//  InstagramTraining
//
//  Created by Keith Cao on 8/07/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import Foundation


struct Comment {
    let text: String
    let uid: String
    let user: User
    init(user:User,dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
