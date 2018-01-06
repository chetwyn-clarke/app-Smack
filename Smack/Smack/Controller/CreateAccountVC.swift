//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Chetwyn on 1/5/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    

}
