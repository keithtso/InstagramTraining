//
//  HomePostCell.swift
//  InstagramTraining
//
//  Created by Keith Cao on 23/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
    
}

class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet{
            guard let imageUrl = post?.imageUrl else{
                return
            }
            
            photoImage.loadImage(urlString: imageUrl)
            likeButton.setImage(post?.hasLike == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            userNameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            
            setUpAttributedCaption()
        }
    }
    
    fileprivate func setUpAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributeText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        guard let caption = post.caption else {
            return
        }
        attributeText.append(NSAttributedString(string: " \(caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributeText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeDisplay = post.postDate?.timeAgoDisplay()
        
        attributeText.append(NSAttributedString(string: timeDisplay!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        captionLabel.attributedText = attributeText
        
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "userName"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return  label
        
    }()
    
    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLike() {
        print("hitting like")
        delegate?.didLike(for: self)
        
    }
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    @objc func handleComment() {
        print("try to show comments")
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
    
    let sendMsgButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
    
        label.numberOfLines = 0
        
        
        return label
    }()
    
    let photoImage: CustomImageView = {
       let imageView = CustomImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
       
        
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(photoImage)
        addSubview(optionButton)
        
        
        userProfileImageView.layoutAnchor(top: topAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, height: 40, width: 40)
        userProfileImageView.layer.cornerRadius = 40/2
        
       
        userNameLabel.layoutAnchor(top: topAnchor, paddingTop: 0, bottom: photoImage.topAnchor, paddingBottom: 0, left: userProfileImageView.rightAnchor, paddingLeft: 8, right: optionButton.leftAnchor, paddingRight: 0, height: 0, width: 0)
        
        optionButton.layoutAnchor(top: topAnchor, paddingTop: 0, bottom: photoImage.topAnchor, paddingBottom: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0, width: 44)
        
        photoImage.layoutAnchor(top: userProfileImageView.bottomAnchor, paddingTop: 8, bottom: nil
            , paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0, width: 0)
        photoImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        
        setUpActionButton()
        
        addSubview(captionLabel)
        captionLabel.layoutAnchor(top: likeButton.bottomAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 8, height: 0, width: 0)
    }
    
    fileprivate func setUpActionButton() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMsgButton])
        
        addSubview(stackView)
        
        stackView.distribution = .fillEqually
      
        stackView.layoutAnchor(top: photoImage.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 4, right: nil, paddingRight: 0, height: 50, width: 120)
        
        addSubview(bookmarkButton)
        bookmarkButton.layoutAnchor(top: photoImage.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 50, width: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
