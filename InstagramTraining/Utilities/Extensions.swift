//
//  Extensions.swift
//  InstagramTraining
//
//  Created by Keith Cao on 26/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import Foundation
import Firebase

extension  Database {
    
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> ()) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String: Any] else {
                return
            }
            let user = User(uid: uid, dictionary: userDict)
            
            completion(user)
            
            
        }) { (err) in
            print("Fail to fetch users ", err)
        }
        
    }
    
}


extension UICollectionViewController {
    
    static func setUpCollectionViewSafearea(view:UIView, collectionView: UICollectionView?) {
        let margin = view.safeAreaLayoutGuide
        collectionView?.layoutAnchor(top: margin.topAnchor , paddingTop: 0, bottom: margin.bottomAnchor, paddingBottom: 0, left: margin.leftAnchor, paddingLeft: 0, right: margin.rightAnchor, paddingRight: 0, height: 0, width: 0)
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = minute * 60
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        
        if secondAgo < minute {
            quotient = secondAgo
            unit = "second"
            
        }else if secondAgo < hour {
            quotient = secondAgo / minute
            unit = "min"
        } else if secondAgo < day {
            quotient = secondAgo / hour
            unit = "hour"
        } else if secondAgo < week {
            quotient = secondAgo / day
            unit = "day"
        }else if secondAgo < month {
            quotient = secondAgo / week
            unit = "week"
        } else {
            quotient = secondAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
    
}

extension UIColor {
    
    static func mainBlue() ->UIColor {
        return UIColor.rgb(r: 17, g: 154, b: 237)
    }
    
    
}
















