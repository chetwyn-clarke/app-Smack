//
//  SocketService.swift
//  Smack
//
//  Created by Chetwyn on 2/12/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    // Create the socket
    
    var manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    // We could also say var socket = SocketManager(socketURL: URL(string: BASE_URL)!).defaultSocket
    
    // MARK: - Configure connections
    
    // Establish / shut the connection between app and server. Establish the connection whenever the app becomes active (i.e. in appDelegate), and close it when the app terminates (again in appDelegate).
    
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    // MARK: - Managing information
    
    // Add channels using Socket. Why do we use a socket? Because we want the channels, once created on the server, to be sent to ALL clients connected to the service, not just this specific user. So we need to do two things: send the channel addition to the server, and then detect when the server sends back the notice that the channel is created. To get the structure of the functions, check the API code. The second function gets the channels back from the server.
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        manager.defaultSocket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        // Call this function in ChannelVC
        
        manager.defaultSocket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    // For the same reason we handle channels with Sockets, we handle messages here as well.
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        manager.defaultSocket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    
    
    
    
    

}
