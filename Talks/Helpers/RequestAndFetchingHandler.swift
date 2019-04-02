//
//  RequestHandler.swift
//  Talks
//
//  Created by Denis Garifyanov on 02/04/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation
import CoreData.NSFetchedResultsController

class RequestAndFetchingHandler {
    static private func addUserToStorage(userID id: String) -> User? {
        return StorageManager.singleton.insert(in: StorageManager.singleton.coreDataStack.mainContext!, aModel: User.self)
    }
    static private func checkUserId(userID id: String) -> [User]? {
        return StorageManager.singleton.findAll(ofType: User.self, in: StorageManager.singleton.coreDataStack.mainContext!, byPropertyName: "id", withMatch: id)
    }
    static func handleUser(userID id: String, complition: (User?) -> Void) {
        var blanc: User
        if let users = self.checkUserId(userID: id) {
            if users.isEmpty {
                blanc = self.addUserToStorage(userID: id)!
                complition (blanc)
                //print("New user added to base\(blanc.id)")
            } else {
                blanc = users.first!
                //print("User already was in base\(blanc.id)")
                complition(users.first)
            }
            print("user is online : \(blanc.online)")
            StorageManager.singleton.coreDataStack.performSave(with: StorageManager.singleton.coreDataStack.mainContext!)
        }
    }
    static func frcForUsers(delegate: NSFetchedResultsControllerDelegate) ->NSFetchedResultsController<User> {
        let users = StorageManager.singleton.findAll(ofType: User.self,
                                         in: StorageManager.singleton.coreDataStack.mainContext!,
                                         byPropertyName: nil, withMatch: nil)
        if users != nil {
            for user in users! {
                user.online = false
                //print("main Gave next User\(user.id)")
            }
        }
        StorageManager.singleton.coreDataStack.performSave(with: StorageManager.singleton.coreDataStack.mainContext!)
        
        return StorageManager.singleton.frcPrepare(
            ofType: User.self,
            sortedBy: "id",
            asscending: false,
            in: StorageManager.singleton.coreDataStack.mainContext!,
            withSelector: nil,
            delegate: delegate,
            predicate: nil,
            offset: 1)
    }
    
    static func frcForMessages(delegate: NSFetchedResultsControllerDelegate, forUser id: String) ->NSFetchedResultsController<Message> {
        let predicate = NSPredicate(format: "conversation.id = %@", id)
        return StorageManager.singleton.frcPrepare(ofType: Message.self,
                                                   sortedBy: "createTimeStamp",
                                                   asscending: true,
                                                   in: StorageManager.singleton.coreDataStack.mainContext!,
                                                   withSelector: nil,
                                                   delegate: delegate,
                                                   predicate: predicate)
    }
    
    static func createMessage(complition: (Message?) -> Void) {
        if let blanc: Message = StorageManager.singleton.insert(in: StorageManager.singleton.coreDataStack.mainContext!, aModel: Message.self) {
            complition(blanc)
        }
        StorageManager.singleton.coreDataStack.performSave(with: StorageManager.singleton.coreDataStack.mainContext!)
    }
    static func createConversation(complition: (Conversation?) -> Void) {
        if let blanc: Conversation = StorageManager.singleton.insert(in: StorageManager.singleton.coreDataStack.mainContext!, aModel: Conversation.self) {
            complition(blanc)
        }
        StorageManager.singleton.coreDataStack.performSave(with: StorageManager.singleton.coreDataStack.mainContext!)
    }
    
    static func fetchLastMessage(byID: String) -> Message? {
        let id = self.checkUserId(userID: byID)?.first?.conversation?.id
        let predicate = NSPredicate(format: "conversation.id = %@", id!)
        guard let blanc = StorageManager.singleton.findLast(in: StorageManager.singleton.coreDataStack.mainContext!, aModel: Message.self, withPredicate: predicate) else {return nil}
        return blanc
    }
}
