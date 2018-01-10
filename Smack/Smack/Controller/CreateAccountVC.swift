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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    @IBAction func createAccntPressed(_ sender: Any) {
        
        guard let email = emailTxt.text , emailTxt.text != "" else { return }
        guard let pass = passTxt.text , passTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("Registered user!")
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        print("Logged in user!", AuthService.instance.authToken)
                    }
                })
            }
        }
    }
    

}
