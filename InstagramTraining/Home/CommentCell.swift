//
//  CommentCell.swift
//  InstagramTraining
//
//  Created by Keith Cao on 8/07/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else { return }
        
            let attributtedText = NSMutableAttributedString(string: comment.user
                .username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributtedText.append(NSAttributedString(string: " " + comment.text, attributes:[ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]))
            textView.attributedText = attributtedText
            
            profileImage.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    let textView: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 14)
        label.isScrollEnabled = false
        label.isEditable = false
        return label
    }()
    
    let profileImage: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .blue
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImage)
        profileImage.layoutAnchor(top: topAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, height: 40, width: 40)
        profileImage.layer.cornerRadius = 40 / 2
        
        
        addSubview(textView)
        textView.layoutAnchor(top: topAnchor, paddingTop: 4, bottom: bottomAnchor, paddingBottom: -4, left: profileImage.rightAnchor, paddingLeft: 4, right: rightAnchor, paddingRight: 4, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
