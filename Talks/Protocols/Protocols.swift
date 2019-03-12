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
    var message : String? {get set}
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
