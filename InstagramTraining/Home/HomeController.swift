//
//  HomeController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 23/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.notificationName, object: nil)
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControll
        
        setUpNavigationItems()
        fetchPosts()
        fetchFollowingPost()
        
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("refreshing")
        posts.removeAll(keepingCapacity: false)
        fetchPosts()
        fetchFollowingPost()
        
    }
    
    fileprivate func fetchFollowingPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String: Any] else {return}
            userDict.forEach({ (key, value) in
                Database.fetchUserWithUid(uid: key, completion: { (user) in
                    self.fetchPostWithUser(user: user)
                })
            })
            
            
        }) { (err) in
            print("Fail to fetch following user posts ", err)
        }    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.fetchPostWithUser(user: user
            )
        }

     
        
    }
    
    fileprivate func fetchPostWithUser(user: User){
        
        let ref = Database.database().reference().child("Posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("like").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLike = true
                    }else {
                        post.hasLike = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { $0.postDate?.compare(($1.postDate)!) == .orderedDescending })
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }, withCancel: { (err) in
                    print("fail to fetch like info", err)
                })
                
                
            })
   
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    fileprivate func setUpNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera() {
        print("show camera")
        
        let cameraContrller = CameraController()
        
        present(cameraContrller, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        
        if indexPath.item < posts.count {
                cell.post = posts[indexPath.item]
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellHeight: CGFloat = 40 + 8 + 8
        cellHeight += view.frame.width
        cellHeight += 50
        cellHeight += 60
        
        return CGSize(width: view.frame.width, height: cellHeight)
    }
    
    
    func didTapComment(post: Post) {
        print("message coming from homecontroller")
        
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        print("handling like inside of the controller")
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        
        guard let postID = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else {return }
        let values = [uid: post.hasLike == true ? 0 : 1]
        Database.database().reference().child("like").child(postID).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("fail to like post: ", err)
                return
            }
            
            print("successfully liked post")
            
            post.hasLike = !post.hasLike
            self.posts[indexPath.item] = post
            
            
            self.collectionView?.reloadItems(at: [indexPath])
            
        }
    }
    
    
}
