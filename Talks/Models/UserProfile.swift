//
//  UserProfile.swift
//  Talks
//
//  Created by Denis Garifyanov on 12/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation
import UIKit



class UserProfile: Codable
{
    var name: String?
    var aboutInformation: String?
    var avatar: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case aboutInformation
        case avatar
    }
 
    init (){
        self.name = nil
        self.aboutInformation = nil
        self.avatar = nil
    }
    init(name: String, aboutInfirmation: String, avatar: UIImage){
        self.name = name
        self.aboutInformation = aboutInfirmation
        self.avatar = avatar
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.avatar)
        guard let image = UIImage(data: data) else {
            print ("error while taking UIImage")
            return
        }
        self.avatar = image
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.aboutInformation = try container.decode(String.self, forKey: CodingKeys.aboutInformation)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avatar!, forKey: CodingKeys.avatar)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(aboutInformation, forKey: CodingKeys.aboutInformation)
    }
    
}

