//
//  MessageCell.swift
//  Smack
//
//  Created by Chetwyn on 2/24/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageBodyLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message: Message) {
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        userNameLbl.text = message.userName
        messageBodyLbl.text = message.message
    }

    

}
