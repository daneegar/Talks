//
//  CommunicationManager.swift
//  Talks
//
//  Created by Denis Garifyanov on 19/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {
    
    let communicator: MultipeerCommunicator = MultipeerCommunicator(RandomData.randomString(length: 6))
    
    
    func didFoundUser(userID: String, userName: String?) {
        
    }
    
    func didLostUser(userID: String) {
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didRecieveMessage(text: String, fromUsers: String, toUser: String) {
        
    }

}
