//
//  ChannelVC.swift
//  Smack
//
//  Created by Chetwyn on 1/2/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        // Create observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            SocketService.instance.getChannel(completion: { (success) in
                if success {
                    self.tableView.reloadData()
                }
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    
    // MARK: - Table view data source and delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChannel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = selectedChannel
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
    }
    
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
    
    @ objc func channelsLoaded(_ notif: Notification) {
        tableView.reloadData()
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
            tableView.reloadData()
        }
    }
    


}
