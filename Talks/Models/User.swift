//
//  User.swift
//  Talks
//
//  Created by Denis Garifyanov on 19/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class User: UserProfile, Equatable{
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
    let userID: String
    var userName: String
    var chat:  Chat
    init(userID: String, userName: String, isOnline: Bool){
        self.userID = userID
        self.userName = userID
        self.chat = Chat(name: self.userName, date: Date(), onlineStatus: true, hasUnreadMessages: false)
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
