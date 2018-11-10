//
//  UserPostCell.swift
//  InstagramTraining
//
//  Created by Keith Cao on 22/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class UserPostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet{
            
            
            guard let imageUrl = post?.imageUrl else{
                return
            }
            
            postImageView.loadImage(urlString: imageUrl)
            
            
           
        }
    }
    
    let postImageView: CustomImageView = {
       let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.4).cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        
        postImageView.layoutAnchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
