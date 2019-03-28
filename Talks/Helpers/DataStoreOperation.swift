//
//  DataStoreOperation.swift
//  Talks
//
//  Created by Denis Garifyanov on 12/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class DataStoreOperation: Operation, DataAsyncStoreProtocol {
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    private let operationQueue = OperationQueue()

    func loadData<T>(inPath url: URL,
                     forModel: T?,
                     completion: @escaping (T?, String?) -> Void) where T: Codable {
        if let data = try? Data(contentsOf: url) {
            var errorMessage: String?
            let operationQueue = OperationQueue.main
            operationQueue.addOperation {
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

    func storeData<T>(data: T,
                      inPath url: URL,
                      forKey: String,
                      completion: ((String?) -> Void)?) where T: Codable {
        print("Using Operations")
        var errorMessage: String?
        let operationQueue = OperationQueue.main
        operationQueue.addOperation {
                do {
                    let data = try self.encoder.encode(data)
                    try data.write(to: url)
                } catch {
                    errorMessage = "save data goes wrong"
                }
                completion?(errorMessage)
        }

    }

}
