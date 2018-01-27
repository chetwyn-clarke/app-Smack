//
//  ProfileVC.swift
//  Smack
//
//  Created by Chetwyn on 1/27/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // MARK: - Functions
    
    func setUpView() {
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        
        // Add gesture recogniser
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func closeModalPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        UserDataService.instance.logOutUser()
        
        // Notify all classes that user has logged out.
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // Dismiss VC
        dismiss(animated: true, completion: nil)
    }
    
    
    
    


}
