//
//  CameraController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 29/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCapturePhoto() {
        print("Capturing photo....")
        
        let setting = AVCapturePhotoSettings()
        
        
        setting.previewPhotoFormat = setting.embeddedThumbnailPhotoFormat
        output.capturePhoto(with: setting, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.layoutAnchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, height: 0, width: 0)
     
    }
    
    let dismissButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        print("dismiss")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    fileprivate func setUpCaptureButtons() {
        view.addSubview(capturePhotoButton)
        view.addSubview(dismissButton)
        
        dismissButton.layoutAnchor(top: view.topAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, height: 50, width: 50)
        
        capturePhotoButton.layoutAnchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: -24, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, height: 80, width: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        setUpCaptureSession()
        
        setUpCaptureButtons()
        
        
    }
    
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismissor = CustomAnimationDismiss()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationDismissor
    }
    
    
    
    let output = AVCapturePhotoOutput()
    
    fileprivate func setUpCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup input
        guard  let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input){
             captureSession.addInput(input)
            }
            
        }catch let err {
            print("fail to set up camera input", err)
        }
        
        //2. setup outputs
        
        if captureSession.canAddOutput(output) {
             captureSession.addOutput(output)
        }
       
        //3 setup output preview
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        
    }
}





