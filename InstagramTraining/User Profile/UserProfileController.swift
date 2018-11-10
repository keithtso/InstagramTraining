//
//  UserProfileController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 16/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UserProfileHeaderDelegate {
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    var isGridView = true
    
    let cellID = "cellID"
    
    var userID: String?
    
    let homePostCellID = "homePostCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        view.backgroundColor = .white
        UICollectionViewController.setUpCollectionViewSafearea(view: view, collectionView: self.collectionView)
        
        fethUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        
        collectionView?.register(UserPostCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellID)
        
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        setUpLogoutButton()
        
    }
    
    fileprivate func setUpLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
        
        
    }
    
    @objc fileprivate func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        present(alertController, animated: true, completion: nil)
        
        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            }catch let err {
                print("Fail to sign out", err)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //how to fire off the paginate cell
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
            
            print("paginate for posts")
            paginatePosts()
            
        }
        
        
        
        if isGridView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserPostCell
            
            cell.post = posts[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellID, for: indexPath) as!HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            if UIDevice.current.orientation.isLandscape {
                
                let width = (collectionView.frame.width - 3) / 3
                
                return CGSize(width: width, height: width)
            }else {
                
                
                let width = (collectionView.frame.width - 3) / 3
                
                return CGSize(width: width, height: width)
            }
        }else {
            var cellHeight: CGFloat = 40 + 8 + 8
            cellHeight += view.frame.width
            cellHeight += 50
            cellHeight += 60
            
            return CGSize(width: view.frame.width, height: cellHeight)
        }
        
        
        
        
    }
    
   override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    switch kind {
        
    case UICollectionView.elementKindSectionHeader:
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
        
    case UICollectionView.elementKindSectionFooter:
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        footer.backgroundColor = .white

//  add an indicator to a footer 
        
        let indicator = UIActivityIndicatorView(style: .gray)
        footer.addSubview(indicator)
        indicator.layoutAnchor(top: footer.topAnchor, paddingTop: 0, bottom: footer.bottomAnchor, paddingBottom: 0, left: footer.leftAnchor, paddingLeft: 0, right: footer.rightAnchor, paddingRight: 0, height: 0, width: 0)
        indicator.startAnimating()
        return footer
        
    default:
        assert(false, "Unexpected element kind")
    }
    
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isFinishedPaging {
            return CGSize(width: 0, height: 0)
        }else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    
    
    var user: User?
    fileprivate func fethUser() {
        
        let uid = userID ?? Auth.auth().currentUser?.uid ?? ""
        
        
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            
            
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            
            self.paginatePosts()
        }
        
        
        
    }
    
    var isFinishedPaging = false
    var posts = [Post]()
    
    
    fileprivate func paginatePosts() {
        print("Start paging four more posts")
        
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("Posts").child(uid)
        
        var query = ref.queryOrdered(byChild: "postDate")
        
        if posts.count > 0 {
            let value = posts.last?.postDate?.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard   var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
           
            
            guard let user = self.user else { return }
            allObjects.forEach({ (snapshot) in
                guard let dict = snapshot.value as? [String: Any] else { return }
                print(snapshot.key)
                var post = Post(user: user, dictionary: dict)
                post.id = snapshot.key
                self.posts.append(post)
            })
            
            self.posts.forEach({ (post) in
                
            })
            
            DispatchQueue.main.async {
                    self.collectionView?.reloadData()
            }
            
            
        }) { (err) in
            print("fail to paginate four post", err)
        }
    }
    
    fileprivate func fetchOrderedPost(){
        
        guard let uid = self.user?.uid else {
            return
        }
        
        
        let ref = Database.database().reference().child("Posts").child(uid)
        ref.queryOrdered(byChild: "postDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dict)
            self.posts.insert(post, at: 0)
      
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("fail to fetch post:", err)
        }
        
        
    }
    
}





