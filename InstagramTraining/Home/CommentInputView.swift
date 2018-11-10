//
//  CommentInputView.swift
//  InstagramTraining
//
//  Created by Keith Cao on 11/07/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

protocol CommentInputViewDelegate {
    func didSend(for comment: String)
}


class CommentInputView: UIView {
    
    var delegate: CommentInputViewDelegate?
    
    func clearCommentTextField() {
        commentTextView.text = nil
        commentTextView.showPlaceholder()
    }
    
    fileprivate let sendButton: UIButton = {
       
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return sendButton
    }()
    
   fileprivate let commentTextView: CommentTextView = {
        let textView = CommentTextView()
        textView.backgroundColor = .red
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    fileprivate func setUpLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.layoutAnchor(top: topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, height: 1, width: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white
        
        let backView = UIView()
        
        addSubview(backView)
        backView.backgroundColor = .white
        backView.layoutAnchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 0, right: safeAreaLayoutGuide.rightAnchor, paddingRight: 0, height: 0, width: 0)
        
        
        backView.addSubview(sendButton)
        
        
        
        
        sendButton.layoutAnchor(top: backView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: backView.rightAnchor, paddingRight: 8, height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.layoutAnchor(top: backView.topAnchor, paddingTop: 8, bottom: backView.bottomAnchor, paddingBottom: -8, left: backView.leftAnchor, paddingLeft: 9, right: sendButton.leftAnchor, paddingRight: 0, height: 0, width: 0)
        
        setUpLineSeparatorView()
        
        
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func handleSend() {
        
        guard let commentText = commentTextView.text else {
            return
        }
        
        delegate?.didSend(for: commentText)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
