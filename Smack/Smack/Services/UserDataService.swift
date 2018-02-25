//
//  UserDataService.swift
//  Smack
//
//  Created by Chetwyn on 1/10/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    public private(set) var id = ""
    
    func setUserData(avatarColor: String, avatarName: String, email: String, name: String, id: String) {
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
        self.id = id
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    // Need to change the avatarColor string into an actual colour.
    
    func returnUIColor(components: String) -> UIColor {
        
        // Reference string from MongoDB: [0.164705882352941, 0.596078431372549, 0.00784313725490196, 1]
        
        // Create and use a scanner to work through the string.
        let scanner = Scanner(string: components)
        
        // Skip square brackets, commas, and whitespace. While scanning, stop at the comma.
        let skippedItems = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skippedItems
        
        // Create variables to save values into.
        
        var r, g, b, a: NSString?
        
        // Execute the scan.
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        // Unwrap the values of type NSString?
        
        let defaultColour = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColour }
        guard let gUnwrapped = g else { return defaultColour }
        guard let bUnwrapped = b else { return defaultColour }
        guard let aUnwrapped = a else { return defaultColour }
        
        // Convert the unwrapped string to a CGFloat by first converting to doubles.
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        // Finally, create the UIColor
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
    }
    
    func logOutUser() {
        
        // Need to set all user variables empty and reset AuthService variables.
        avatarColor = ""
        avatarName = ""
        email = ""
        name = ""
        id = ""
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
        
    }
    
    
    
    
    
    
    
    
    
    
}
