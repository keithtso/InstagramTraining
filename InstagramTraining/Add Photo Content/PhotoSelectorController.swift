//
//  PhotoSelectorController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 20/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        setUpNavBarItem()
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "cellID")
        
        collectionView?.register(PhotoSelectorCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        fetchPhotos()
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! PhotoSelectorCell
        cell.image.image = images[indexPath.row]
        cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    var header: PhotoSelectorCell?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! PhotoSelectorCell
       
        self.header = header
        header.image.image = headerImage
        
        if let headerImage = headerImage {
        if let index = self.images.index(of: headerImage) {
            let imageManager = PHImageManager.default()
            imageManager.requestImage(for: self.assets[index], targetSize: CGSize(width: 600, height: 600), contentMode:.aspectFit, options: nil) { (image, info) in
                
                header.image.image = image
            }
        }
        }
        
    
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    var headerImage: UIImage?
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        headerImage = images[indexPath.row]
        collectionView.reloadData()
    
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setUpNavBarItem() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        
    }
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    fileprivate func assetsFetchOption() -> PHFetchOptions {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 100
        let sortDes = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOption.sortDescriptors = [sortDes]
        return fetchOption
    }
    
    fileprivate func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with:.image, options: assetsFetchOption())
        
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200 , height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode:.aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        print("fetching image")
                        
                        if self.headerImage == nil {
                            self.headerImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.sync {
                            self.collectionView?.reloadData()
                        }
                        
                    }
                    
                })
            }
        }
       
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleNext() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.sharePhotoImage = header?.image.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
}
