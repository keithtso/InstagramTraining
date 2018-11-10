//
//  ViewController.swift
//  InstagramTraining
//
//  Created by Keith Cao on 13/06/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusButton)
        
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.layoutAnchor(top: view.topAnchor, paddingTop: 140, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, height: 140, width: 140)
        
        setUpInputField()
        
        view.addSubview(haveAnAccountButton)
        haveAnAccountButton.layoutAnchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: -20, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, height: 50, width: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @objc func handleKeyboardNotification() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    fileprivate func setUpInputField() {
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, nameTextField, passwordTextField, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [stackView.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 20),
             stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
             stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
             stackView.heightAnchor.constraint(equalToConstant: 200)])
        
        stackView.layoutAnchor(top: plusButton.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 40, right: view.rightAnchor, paddingRight: 40, height: 200, width: 0)
        
    }
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAddPhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            plusButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusButton.layer.cornerRadius = plusButton.frame.width/2
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = UIColor.black.cgColor
        plusButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField : UITextField = {
        let emailTF = UITextField()
        emailTF.placeholder = "Email"
        emailTF.backgroundColor = UIColor(white: 0, alpha: 0.03)
        emailTF.borderStyle = .roundedRect
        emailTF.font = UIFont.systemFont(ofSize: 14)
        emailTF.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return emailTF
        
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && nameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rgb(r: 17, g: 154, b: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
           signUpButton.backgroundColor = UIColor.rgb(r: 149, g: 204, b: 244)
        }
    }
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
        
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
        
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return  button
    }()
    
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text, let userName = nameTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if err != nil {
                print("Fail to create user", err as Any)
            }
            
            guard let image = self.plusButton.imageView?.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
            
            let fileName = NSUUID().uuidString
            let storageChildRef = Storage.storage().reference().child("profile_images").child(fileName)
            storageChildRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Fail to upload profile image", err)
                    return
                }
            
                storageChildRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Fail to get the image url",err)
                        return

                    }

                    guard let profileImageUrl = url?.absoluteString else { return }

                    print(profileImageUrl)

                    guard let uid = user?.user.uid else { return }
                    print("this uid is ",uid)
                    let dictionaryValues =  ["username": userName, "email": email, "profileImageUrl":profileImageUrl]
                    let values = [uid: dictionaryValues]

                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to save user info into db ", err)
                            return
                        }

                        print("successfully saved user info to db")
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        mainTabBarController.setUpViewController()
                        self.dismiss(animated: true, completion: nil)
                        

                    })

                })

            })
            
            
            
        }
    }
    
    let haveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(r: 17, g: 154, b: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLogin() {
        navigationController?.popViewController(animated: true)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
