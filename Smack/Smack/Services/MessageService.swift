//
//  MessageService.swift
//  Smack
//
//  Created by Chetwyn on 2/5/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

//  This file will be responsible for storing messages, channels, and the functionality for retrieving them.

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel: Channel?
    
    func getAllChannels(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get
            , parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
                
                if response.result.error == nil {
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id = item["_id"].stringValue
                            let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                            self.channels.append(channel)
                        }
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                        completion(true)
                    }
                        
                    } catch {
                        debugPrint(error)
                    }
                    
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func getAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        
        print("Started getAllMessagesForChannel function.")
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId))", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                
                print("Started Alamofire request")
                
                self.clearMessages()
                
                guard let data = response.data else { return }
                
                do {
                    
                    print("Started do part of Alamofire request")
                    
                    if let json = try JSON(data: data).array {
                        
                        print("Entered if section of AlamoFire request")
                        
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["_id"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            
                            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                            self.messages.append(message)
                            print("Successful try for JSON array.")
                        }
                        completion(true)
                        print("Completed getting messages.")
                    }
                } catch {
                    print("Unable to do json download. Why? \(error)")
                    debugPrint(error)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
