//
//  UserProfileExtension.swift
//  Talks
//
//  Created by Denis Garifyanov on 26/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation
import CoreData

extension UserProfile {

    static func insert(in context: NSManagedObjectContext) -> UserProfile? {
        var userProfile: UserProfile?
        context.performAndWait {
            userProfile = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: context) as? UserProfile
        }
        return userProfile
    }
    static func findOrInsert(in context: NSManagedObjectContext) -> UserProfile? {
        var userProfile: UserProfile?
        context.performAndWait {
            userProfile = find(in: context)
            
            if userProfile == nil {
                userProfile = UserProfile.insert(in: context)
            }
        }
        return userProfile
    }
    
    static func fetchRequest(model: NSManagedObjectModel) ->NSFetchRequest<UserProfile>? {
        let temp = "UserProfile"
        guard let fetchRequest = model.fetchRequestTemplate(forName: temp) as? NSFetchRequest <UserProfile> else {
            print("Fetching is not correct")
            return nil
        }
        return fetchRequest
    }
    
    static func find(in context: NSManagedObjectContext) -> UserProfile? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Problem with modeling")
            return nil
        }
        var userProfile: UserProfile?
        guard let fetchRequest = UserProfile.fetchRequest(model: model) else {
            print("fetching")
            return nil
        }
        context.performAndWait {
            do {
                let result = try context.fetch(fetchRequest)
                userProfile = result.first
                
            } catch {
                print("FUCK")
            }
        }
        return userProfile
    }
    
}

