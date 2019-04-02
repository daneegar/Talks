//
//  User.swift
//  Talks
//
//  Created by Denis Garifyanov on 19/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

struct UserStruct: Equatable {
    static func == (lhs: UserStruct, rhs: UserStruct) -> Bool {
        return lhs.userID == rhs.userID
    }
    let userID: String
    var userName: String
    var chat: Chat
    init(userID: String, userName: String, isOnline: Bool) {
        self.userID = userID
        self.userName = userID
        self.chat = Chat(name: self.userName, date: Date(), onlineStatus: true, hasUnreadMessages: false)
    }
    public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
