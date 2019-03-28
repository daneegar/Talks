//
//  Message.swift
//  Talks
//
//  Created by Denis Garifyanov on 24/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation
import CoreData

class Message: MessageCellConfiguration, Encodable, Decodable {
    var text: String?
    var typeOfMessage: MessageType
    var createTimeStamp: Date?
    var dateOfWasReaded: Date?
    var dateOfWasEdited: Date?
    //var nextMessage: Message?
    var isUnReaded: Bool?
    var messageID: String?

    private enum CodingKeys: String, CodingKey {
        case text
        case messageID
        case iventType
    }
    init(messageID: String, text: String?, typeOfMessage: MessageType) {
        self.messageID = messageID
        self.text = text
        self.typeOfMessage = typeOfMessage
        self.createTimeStamp = Date()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let text = self.text {
            try container.encode(text, forKey: CodingKeys.text)
        } else {
            try container.encode("emptyMessage", forKey: CodingKeys.text)
        }
        try container.encode(messageID, forKey: CodingKeys.messageID)
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.typeOfMessage = .inComingMessage
        self.text = try container.decode(String.self, forKey: CodingKeys.text)
        self.messageID = try container.decode(String.self, forKey: CodingKeys.messageID)
        self.createTimeStamp = Date()
    }
}
