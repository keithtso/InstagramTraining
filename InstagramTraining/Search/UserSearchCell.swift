//
//  UserSearchCell.swift
//  InstagramTraining
//
//  Created by Keith Cao on 26/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet {
            userNameLabel.text = user?.username
            
            guard let imageUrl = user?.profileImageUrl else { return }
             profileImageView.loadImage(urlString: imageUrl)
            
        }
        
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .yellow
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    
    }()
    
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "user name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
        addSubview(profileImageView)
        addSubview(userNameLabel)
        
        
        profileImageView.layoutAnchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, height: 50, width: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        userNameLabel.layoutAnchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: profileImageView.rightAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 0, height: 0, width: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.layoutAnchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: userNameLabel.leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0.5, width: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
