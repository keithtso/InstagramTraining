//
//  CustomAnimationPresentor.swift
//  InstagramTraining
//
//  Created by Keith Cao on 3/07/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //custom animation transition code
        
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }  //the view that will transist to
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        
        toView.frame = startingFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            //animation here
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            
        }) { (_) in
                transitionContext.completeTransition(true)
        }
        
        
    }
}
