//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Chetwyn on 1/5/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            
            // If user selects a light avatar initially, with no background color, set a default of a light grey background color.
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        // Create random red, blue, and green values
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        // Create background colour
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        // Set the background color with a fade transition between changes
        UIView.animate(withDuration: 0.25) {
            self.userImg.backgroundColor = self.bgColor
        }
        
    }
    
    @IBAction func createAccntPressed(_ sender: Any) {
        
        //Show spinner
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let userName = usernameTxt.text , usernameTxt.text != "" else { return }
        guard let email = emailTxt.text , emailTxt.text != "" else { return }
        guard let pass = passTxt.text , passTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("Registered user!")
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        print("Logged in user!")
                        AuthService.instance.createUser(name: userName, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print("User created successfully: \(UserDataService.instance.name), \(UserDataService.instance.avatarName)")
                                
                                // Hide spinner if successfully added a user
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                                
                                // Post notification that we have created a user.
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func setUpView() {
        // Start with spinner hidden
        spinner.isHidden = true
        
        // Set textfield placeholders to purple colour
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: purplePlaceHolderTextColor])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "e-mail", attributes: [NSAttributedStringKey.foregroundColor: purplePlaceHolderTextColor])
        passTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: purplePlaceHolderTextColor])
        
        //Add a tap gesture recognizer to view
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        //Dismiss kepyboard
        view.endEditing(true)
    }

}
