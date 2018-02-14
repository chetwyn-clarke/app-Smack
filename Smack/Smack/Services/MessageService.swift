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
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
