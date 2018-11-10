//
//  MainTabBarController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 16/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase


class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let naviController = UINavigationController(rootViewController: loginController)
                self.present(naviController, animated: true, completion: nil)
                
            }
            return
        }
        
        setUpViewController()
        
    }
    
    
      func setUpViewController() {
        //home section
        let homeNavController = templateNavController(image: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        //search section
        let searchNavController = templateNavController(image: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        
        //add content section
        let plusContentNavController = templateNavController(image: #imageLiteral(resourceName: "plus_unselected"), selectedImage: nil)
        
        //like section
        let likeNavController = templateNavController(image: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        
        //user profile section
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,searchNavController,plusContentNavController,likeNavController,userProfileNavController]
        
        // modify tab bar item insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    private func templateNavController(image: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        if let image = image {
        
            navController.tabBarItem.image = image
        }
        if let selectedImage = selectedImage {
            navController.tabBarItem.selectedImage = selectedImage
        }
        return navController
    }
    
}
