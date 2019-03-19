//
//  Chat.swift
//  Talks
//
//  Created by Denis Garifyanov on 21/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class Chat: ConversationCellConfiguration {
    var name: String?
    var message: Message?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    init(name: String?, date: Date?, onlineStatus: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.date = date
        self.online = onlineStatus
        self.hasUnreadMessages = hasUnreadMessages
    }
}
