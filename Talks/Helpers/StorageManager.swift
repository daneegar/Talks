//
//  StorageManager.swift
//  Talks
//
//  Created by Denis Garifyanov on 26/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//



import Foundation
import CoreData

class StorageManager {
    private init() {
    }
    
    static let singletone = StorageManager()

    let coreDataStack = CoreDataStack()
    
    
    func loadUserProfileInMainThread () -> UserProfile? {
        if let context = self.coreDataStack.mainContext {
            return UserProfile.findOrInsert(in: context)
        }
        print("context in load operation wasn't created")
        return nil
    }
    
    func storeDateInMainThread(complition: @escaping ()->Void){
        if let context = self.coreDataStack.mainContext {
            self.coreDataStack.performSave(with: context) {
                complition()
            }
            return
        }
        print("context in saving operation wasn't created")
    }
    
    
}
