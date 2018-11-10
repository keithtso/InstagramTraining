//
//  CustomImageView.swift
//  InstagramTraining
//
//  Created by Keith Cao on 23/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit


//iamge caching which avoids the UI keeps refreshing, reduces the user's data plan useage
var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        self.image = nil
        lastUrlUsedToLoadImage = urlString
        
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Fail to feth post image", err)
                return
            }
            
            //check whether an image is loading from a correct url
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }

            
            //fetch extenal image data from an url
            guard let imageData = data else {return}
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
                
            }
            
            }.resume()
    }
    
}
