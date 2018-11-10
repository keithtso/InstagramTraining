//
//  UserProfileHeader.swift
//  InstagramTraining
//
//  Created by Keith Cao on 17/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet{
            
            guard let profileImageUrl = user?.profileImageUrl else {
                return
            }
            profileImageView.loadImage(urlString: profileImageUrl)
            //   setUpProfileImage()
            userNamgeLabel.text = user?.username
            
            setUpEditFollowButton()
            
            
        }
    }
    
    fileprivate func setUpEditFollowButton() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        guard let userID = user?.uid else { return }
        
        if userID == currentUserID {
            self.editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        } else {
            //check if following the user
            Database.database().reference().child("following").child(currentUserID).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.setUpUnfollow()
                } else {
                    self.setUpFollow()
                }
                
            }) { (err) in
                print("fail to check the following status ", err)
            }
            
            
            
        }
        
        
        
    }
    
    fileprivate func setUpFollow() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(r: 17, g: 154, b: 237)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setUpUnfollow() {
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
    }
    
    @objc func handleEditProfileOrFollow() {
        
        guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else { return }
        guard let userID = user?.uid else {return }
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("following").child(currentLoggedInUserID).child(userID).removeValue { (err, ref) in
                if let err = err {
                    print("fail to unfollow user: ", err)
                    return
                }
                
                print("successfully unfollow")
                self.setUpFollow()
                return
            }
        } else if editProfileFollowButton.titleLabel?.text == "Follow"{
            
            
            let ref = Database.database().reference().child("following").child(currentLoggedInUserID)
            let values = [userID: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("fail to follow user: ", err)
                    return
                }
                
                self.setUpUnfollow()
                return
                
            }
        } else {
            print("edit profile here")
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImageView)
        setUpProfileImageAnchor()
        
        
        setUpBottomToolbar()
        addSubview(userNamgeLabel)
        userNamgeLabel.layoutAnchor(top: profileImageView.bottomAnchor, paddingTop: 12, bottom: gridButton.topAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 12, right: rightAnchor, paddingRight: 12, height: 0, width: 0)
        
        setUpUserStackView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.layoutAnchor(top: postLabel.bottomAnchor, paddingTop: 6, bottom: nil, paddingBottom: 0, left: profileImageView.rightAnchor, paddingLeft: 6, right: rightAnchor, paddingRight: 12, height: 30, width: 0)
    }
    
    
    fileprivate func setUpProfileImageAnchor() {
        profileImageView.layoutAnchor(top: topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 12, right: nil, paddingRight: 0, height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.layer.masksToBounds = true
        
    }
    
    
    fileprivate func setUpBottomToolbar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        addSubview(stackView)
        stackView.layoutAnchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 50, width: 0)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        
        topDividerView.layoutAnchor(top: stackView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0.5, width: 0)
        
        bottomDividerView.layoutAnchor(top: stackView.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0.5, width: 0)
    }
    
    
    fileprivate func setUpUserStackView() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followerLabel, followingLabel])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.layoutAnchor(top: topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, left: profileImageView.rightAnchor, paddingLeft: 12, right: rightAnchor, paddingRight: 12, height: 50, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .black
        
        return imageView
        
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToGridView() {
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        gridButton.tintColor = UIColor.mainBlue()
        delegate?.didChangeToGridView()
    }
    
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToListView() {
        print("change to list view")
        listButton.tintColor = UIColor.mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    let userNamgeLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return  label
    }()
    
    let followerLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return  label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return  label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    
}
