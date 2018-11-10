//
//  SharePhotoController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 21/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var sharePhotoImage: UIImage? {
        didSet{
            
            self.imageView.image = sharePhotoImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 240, g: 240, b: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePost))
        
        setUpImageAndTextView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return  true
    }
    
    fileprivate func setUpImageAndTextView() {
        
        let containerView = UIView()
        
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.layoutAnchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0, right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0, height: 100, width: 0)
        
        containerView.addSubview(imageView)
        containerView.addSubview(textView)
        
        
        imageView.layoutAnchor(top: containerView.topAnchor, paddingTop: 5, bottom: containerView.bottomAnchor, paddingBottom: -5, left: containerView.leftAnchor, paddingLeft: 5, right: nil, paddingRight: 0, height: 0, width: 100)
        
        textView.layoutAnchor(top: containerView.topAnchor, paddingTop: 5, bottom: containerView.bottomAnchor, paddingBottom: -5, left: imageView.rightAnchor, paddingLeft: 5, right: containerView.rightAnchor, paddingRight: 5, height: 0, width: 0)
        
    }
    
    let imageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    let textView: UITextView = {
        let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 3
        tf.clipsToBounds = true
        
        return tf
        
    }()
    
    @objc fileprivate func handlePost() {
        guard let image = sharePhotoImage else { return }
        guard let upLoadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = NSUUID().uuidString
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        let childRef = Storage.storage().reference().child("Posts").child(filename)
            childRef.putData(upLoadData, metadata: nil) { (metaData, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Fail to upload post image", err)
                return
            }
            
                childRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        print("Fail to downLoadURL", err)
                        return
                    }
                    
                    guard let imageUrl = url?.absoluteString else {return}
                    
                    print("successfully upload image",imageUrl)
                    
                    self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
                    
                })
        }
        
        
    }
    
    
    static let notificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    //save a list of data to the firebase database
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        guard let userInputText = textView.text else { return }
        
        guard let postImage = sharePhotoImage else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("Posts").child(uid)
        
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl": imageUrl, "PostText": userInputText, "imageWidth":postImage.size.width, "imageHeight":postImage.size.height, "postDate": Date().timeIntervalSince1970] as [String: Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Fail to save post to db", err)
                return
            }
            
            print("successfully save post to db")
            
        }
        dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: SharePhotoController.notificationName, object: nil)
    }
    
    
}
