//
//  UserSearchController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 26/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.barTintColor = .gray
        
        //change the textfield color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(r: 240, g: 240, b: 240)
        searchBar.delegate = self
        return searchBar
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        searchBar.isHidden = false
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
           filterUsers = self.users
          print(filterUsers)
        }else {
            filterUsers = users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }

        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filterUsers[indexPath.item]
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()    //hide the keyboard
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userID = user.uid
        
        
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.keyboardDismissMode = .onDrag
        
//      set up the layout with safe area layout guide
        let margin = view.safeAreaLayoutGuide
        collectionView?.layoutAnchor(top: view.topAnchor , paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: margin.leftAnchor, paddingLeft: 0, right: margin.rightAnchor, paddingRight: 0, height: 0, width: 0)
        
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.layoutAnchor(top: navBar?.topAnchor, paddingTop: 0, bottom: navBar?.bottomAnchor, paddingBottom: 0, left: navBar?.safeAreaLayoutGuide.leftAnchor, paddingLeft: 4, right: navBar?.safeAreaLayoutGuide.rightAnchor, paddingRight: 4, height: 0, width: 0)
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellID)
        
        fetchUsers()
    }
    
    
    var filterUsers = [User]()
    var users = [User]()
    
    
    fileprivate func fetchUsers() {
        
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let dict = snapshot.value as? [String: Any] else { return }
            
            dict.forEach({ (key, value) in
                
                if key == Auth.auth().currentUser?.uid {
                    print("found myself")
                    return
                }
                
                guard let userDict = value as? [String: Any] else { return }
                
                let user = User(uid: key, dictionary: userDict)
                self.users.append(user)
                
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                
                return u1.username.compare(u2.username) == .orderedAscending
                
            })
            
            self.filterUsers = self.users
            
     
            self.collectionView?.reloadData()
            
            
        }) { (err) in
            print("Fail to fetch users: ", err)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserSearchCell
        cell.profileImageView.image = nil   //set the profileImage to nil whenever load it to the cell
        cell.user = filterUsers[indexPath.item]
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 66)
    }
}
