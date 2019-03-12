//
//  dataStoreGCD.swift
//  Talks
//
//  Created by Denis Garifyanov on 12/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation


class DataStoreGCD: DataAsyncStoreProtocol{
    
    
    
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    let serialQueue = DispatchQueue(label: "concurrency.DataStoredGCD.serial")
    
    
    func storeData <T:Codable> (data: T, inPath url: URL, forKey: String, completion: ((String?)->Void)?){
        print("Using GCD")
        var errorMessage: String?
        serialQueue.async {
            do {
                let data = try self.encoder.encode(data)
                try data.write(to: url)
            } catch {
                errorMessage = "save data goes wrong"
            }
            completion?(errorMessage)
        }
    }

    
    
    func loadData <T: Codable> (inPath url: URL, forModel: T?, completion: @escaping (T?, String?)->Void){
        if let data = try? Data(contentsOf: url){
            var errorMessage: String?
            serialQueue.async {
                do {
                    let userProfile = try self.decoder.decode(T.self, from: data)
                    completion(userProfile, nil)
                } catch {
                    errorMessage = "load data goes wrong"
                    completion(nil, errorMessage)
                }
                
            }
        }
    }
    

    
    
}
