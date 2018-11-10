//
//  UIColor.swift
//  InstagramTraining
//
//  Created by Keith Cao on 13/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(r:CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
