//
//  CommunicationManager.swift
//  Talks
//
//  Created by Denis Garifyanov on 19/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {

    init(delegate: CommunicatorViewControllerDelegate, peerID: String) {
        self.communicator = MultipeerCommunicator(peerID)
        self.delegate = delegate
        self.communicator.delegate = self
    }

    weak var delegate: CommunicatorViewControllerDelegate!

    var listOfPeers: [User]  = []

    let communicator: MultipeerCommunicator

    func didFoundUser(userID: String, userName: String?) {
        var name: String
        if let userName = userName {
            name = userName
        } else {
            name = "default"
        }
        self.listOfPeers.append(User(userID: userID, userName: name, isOnline: true))
        self.delegate.communicationManagerFoundNewUser()
    }

    func didLostUser(userID: String) {
        let tempUser = User(userID: userID, userName: userID, isOnline: true)
        if let index = listOfPeers.index(of: tempUser) {
            listOfPeers.remove(at: index)
        }
        self.delegate.communicationManagerFoundNewUser()
    }

    func failedToStartBrowsingForUsers(error: Error) {

    }

    func failedToStartAdvertising(error: Error) {

    }

    func didRecieveMessage(text: Message, fromUser: String, toUser: String) {
        let tempUser = User(userID: fromUser, userName: fromUser, isOnline: true)
        if let index = listOfPeers.index(of: tempUser) {
            listOfPeers[index].chat.addMessage(message: text)
            self.delegate.communicationManagerRecieveMessage(forUser: listOfPeers[index])
        }
    }

    func findUser(byDisplayName userID: String) -> User? {
        let tempUser = User(userID: userID, userName: userID, isOnline: true)
        if let index = listOfPeers.index(of: tempUser) {
            return listOfPeers[index]
        }
        return nil
    }

}
