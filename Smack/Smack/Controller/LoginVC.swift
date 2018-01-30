//
//  LoginVC.swift
//  Smack
//
//  Created by Chetwyn on 1/5/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // MARK: - Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        
        // First, log user in with username and password, then use loginUser function in AuthServices to login. API will return to us the e-mail and authToken; we save those to AuthServices, and then user the findUserByEmail to get userData to display.
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameTxt.text, usernameTxt.text != "" else { return }
        
        guard let pass = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            
            // If login is successful, then find user by e-mail to get userData
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    
                    // If we find the user, then notify everyone who needs to know that we have changed the userData.
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAcctBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    // MARK: - Functions
    
    func setUpView() {
        // Start with spinner hidden
        spinner.isHidden = true
        
        // Set textfield placeholders to purple colour
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: purplePlaceHolderTextColor])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: purplePlaceHolderTextColor])
    }
}
