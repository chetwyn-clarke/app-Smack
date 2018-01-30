//
//  ChannelVC.swift
//  Smack
//
//  Created by Chetwyn on 1/2/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    
    // MARK: - View Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        // Create an observer for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    
    // MARK: - Actions
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            
            // Segue to profile page
            let profilePage = ProfileVC()
            profilePage.modalPresentationStyle = .custom
            present(profilePage, animated: true, completion: nil)
            
        } else {
            // Show login page
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    //MARK: - Functions
    
    @objc func userDataDidChange(_ notif: Notification) {
        setUpUserInfo()
    }
    
    func setUpUserInfo() {
        // If the user is logged in, set the login button title and image.
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
        }
    }
    


}
