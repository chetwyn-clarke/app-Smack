//
//  AddChannelVC.swift
//  Smack
//
//  Created by Chetwyn on 2/7/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var chanDescription: UITextField!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Functions
    
    func setUpView() {
        
        // Add gesture recognizer to close view if you tap outside its bounds.
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        // Set up textfields
        
        nameText.attributedPlaceholder = NSAttributedString(string: "name", attributes:[NSAttributedStringKey.foregroundColor : purplePlaceHolderTextColor])
        chanDescription.attributedPlaceholder = NSAttributedString(string: "description", attributes:[NSAttributedStringKey.foregroundColor : purplePlaceHolderTextColor])
        
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let channelName = nameText.text, nameText.text != "" else { return }
        guard let channelDesc = chanDescription.text else { return }
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}
