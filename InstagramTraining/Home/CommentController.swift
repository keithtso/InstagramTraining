//
//  CommentController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 4/07/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController,UICollectionViewDelegateFlowLayout, CommentInputViewDelegate {
   
    
    func didSend(for comment: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let postID = self.post?.id ?? ""
        let values = ["text": comment, "postDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        
        Database.database().reference().child("comment").child(postID).childByAutoId().updateChildValues(values) { (err, ref) in
            
            if let err = err {
                print("Failed to insert comment:",err)
                return
            }
        }
        
        print("inserted coomment")
        
        self.containerView.clearCommentTextField()
        
    }
    
    
    var post: Post?
    let cellID = "CellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        tabBarController?.tabBar.isHidden = true
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellID)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)

        
        fetchComments()
        
    }
    
    @objc func handleKeyboardNotification() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var comments = [Comment]()
    
    fileprivate func fetchComments() {
        
        guard let postId = self.post?.id else {return}
        let ref = Database.database().reference().child("comment").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }
            
            Database.fetchUserWithUid(uid: uid, completion: { (user) in
                
                let comment = Comment(user: user, dictionary: dict)
                
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
            
            
            
        }) { (err) in
            print("fail to observe comments")
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //dynamic cell size
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        

    }
    
    
    lazy var containerView: CommentInputView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputView = CommentInputView(frame: frame)
        commentInputView.delegate = self
        return commentInputView
        
    }()

    
    
    override var inputAccessoryView: UIView? {
        get {
   
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
