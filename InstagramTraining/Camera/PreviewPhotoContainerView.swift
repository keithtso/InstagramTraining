//
//  PreviewPhotoContainerView.swift
//  InstagramTraining
//
//  Created by Keith Cao on 30/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
       let iv = UIImageView()
        
        return iv
        
    }()
    
    let saveButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSave() {
        print("handling save image")
        
        guard let previewImage = previewImageView.image else {return}
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
            
        }) { (sucess, err) in
            if let err = err {
                print("fail to save the image to the library ", err)
                return
            }
            
            print("saved to the library")
            
            DispatchQueue.main.async {
                let saveLabel = UILabel()
                saveLabel.text = "Saved Successfully"
                saveLabel.textColor = .white
                saveLabel.font = UIFont.boldSystemFont(ofSize: 18)
                saveLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                saveLabel.numberOfLines = 0
                saveLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                saveLabel.textAlignment = .center
                saveLabel.center = self.center
                
                self.addSubview(saveLabel)
                
                saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }, completion: { (completed) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        
                        saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        
                    }, completion: { (completed) in
                        saveLabel.removeFromSuperview()
                    })
                })
            }
            
            
            
        }
        
    }
    
    let cancellButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(previewImageView)
        previewImageView.layoutAnchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 0, width: 0)
        
        addSubview(cancellButton)
        cancellButton.layoutAnchor(top: topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 12, right: nil, paddingRight: 0, height: 50, width: 50)
        
        addSubview(saveButton)
        saveButton.layoutAnchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: -24, left: leftAnchor, paddingLeft: 24, right: nil, paddingRight: 0, height: 50, width: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
