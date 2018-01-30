//
//  AuthServices.swift
//  Smack
//
//  Created by Chetwyn on 1/9/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// This will handle all services for registering and creating a user.

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        //The API is a bit unique in that for this particular task it returns a string, so we have to specify that in the Alamofire request. Normally you would want a JSON return, and would specify that; so you need to know what your API is asking for.
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //We get back a JSON object, so we have to parse it! First method is manually,
                
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
                //Using SwiftyJSON
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                } catch {
                    debugPrint(error)
                }
                
                self.isLoggedIn = true
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let name = json["name"].stringValue
                    let email = json["email"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let avatarColor = json["avatarColor"].stringValue
                    
                    UserDataService.instance.setUserData(avatarColor: avatarColor, avatarName: avatarName, email: email, name: name, id: id)
                    
                    completion(true)
                } catch {
                    debugPrint(error)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        // This function will be used to log in the user: with the authToken and the userEmail we can get the remainder of their information.
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let name = json["name"].stringValue
                    let email = json["email"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let avatarColor = json["avatarColor"].stringValue
                    
                    UserDataService.instance.setUserData(avatarColor: avatarColor, avatarName: avatarName, email: email, name: name, id: id)
                    
                    completion(true)
                } catch {
                    debugPrint(error)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
        
    }
    
    func setUserInfo(data: Data) {
        //TODO: Create this function to handle the JSON parse in createUser and findUserByEmail functions so that I don't violate the DRY principle.
    }
    
    
}
