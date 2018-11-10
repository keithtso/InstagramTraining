//
//  CommentTextView.swift
//  InstagramTraining
//
//  Created by Keith Cao on 12/07/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class CommentTextView: UITextView {
    
    fileprivate let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "Say something..."
        label.textColor = UIColor.lightGray
        return label
    }()
    
    
    func showPlaceholder() {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        placeholderLabel.layoutAnchor(top: topAnchor, paddingTop: 8, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 0, height: 0, width: 0)
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
