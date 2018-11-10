//
//  PhotoSelectorCell.swift
//  InstagramTraining
//
//  Created by Keith Cao on 20/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        image.layoutAnchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0, width: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let image: UIImageView = {
        
        let image = UIImageView(image: #imageLiteral(resourceName: "plus_photo"))
        
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        return image
    }()
}
