//
//  randomsData.swift
//  Talks
//
//  Created by Denis Garifyanov on 24/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class RandomData {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    static func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
}
