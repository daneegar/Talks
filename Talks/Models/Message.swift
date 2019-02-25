//
//  Message.swift
//  Talks
//
//  Created by Denis Garifyanov on 24/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class Message: MessageCellConfiguration {
    var text: String?
    let typeOfMessage: MessageType
    var dateOfPublic: Date?
    var dateOfWasReaded: Date?
    var dateOfWasEdited: Date?
    init(text: String?, typeOfMessage: MessageType) {
        self.text = text
        self.typeOfMessage = typeOfMessage
    }
}

