//
//  ChatVC.swift
//  Smack
//
//  Created by Chetwyn on 1/2/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var menuBtn: UIButton!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // If user is logged in, set up the view.
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        

        
    }



}
