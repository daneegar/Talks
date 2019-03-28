//
//  AppDelegate.swift
//  Talks
//
//  Created by Denis Garifyanov on 09/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let threadLogger = ThreadLogger(typeOfThread: .application)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.self.threadLogger.printStep()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.self.threadLogger.printStep()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.self.threadLogger.printStep()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.self.threadLogger.printStep()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.self.threadLogger.printStep()
    }

    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Talks")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
