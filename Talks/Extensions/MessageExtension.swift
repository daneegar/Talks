
import Foundation
import CoreData

extension Message {
    
    static func insert(in context: NSManagedObjectContext) -> Message? {
        var userProfile: Message?
        context.performAndWait {
            userProfile = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message
        }
        return userProfile
    }
    static func findOrInsert(in context: NSManagedObjectContext) -> Message? {
        var userProfile: Message?
        context.performAndWait {
            userProfile = find(in: context)
            
            if userProfile == nil {
                userProfile = Message.insert(in: context)
            }
        }
        return userProfile
    }
    
    static func fetchRequest(model: NSManagedObjectModel) ->NSFetchRequest<Message>? {
        let temp = "Message"
        guard let fetchRequest = model.fetchRequestTemplate(forName: temp) as? NSFetchRequest <Message> else {
            print("Fetching is not correct")
            return nil
        }
        
        return fetchRequest
    }
    
    static func find(in context: NSManagedObjectContext) -> Message? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Problem with modeling")
            return nil
        }
        var userProfile: Message?
        guard let fetchRequest = Message.fetchRequest(model: model) else {
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
