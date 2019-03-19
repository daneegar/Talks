//
//  Protocols.swift
//  Talks
//
//  Created by Denis Garifyanov on 21/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration: class {
    var name : String? {get set}
    var message : Message? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages : Bool {get set}
}

protocol MessageCellConfiguration: class {
    var text : String? {get set}
}


protocol DataAsyncStoreProtocol {
    func loadData <T: Codable> (inPath url: URL, forModel: T?, completion: @escaping (T?, String?)->Void)
    func storeData <T: Codable> (data: T, inPath url: URL, forKey: String, completion: ((String?)->Void)?)
}


protocol Communicator {
    func sendMessage(string: String, to userID: String, complitionHandler : ((_ success: Bool, _ error: Error?)->())?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol  CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error : Error)
    func failedToStartAdvertising(error : Error)
    
    //messages
    func didRecieveMessage(text: String, fromUsers: String, toUser: String)
}

protocol CommunicatorViewControllerDelegate: class {
    func communicationManagerFoundNewUser()
    func communicationManagerRecieveMessage(forUser: User)
}
