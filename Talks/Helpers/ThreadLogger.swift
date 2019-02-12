//
//  LifeCirlce.swift
//  Talks
//
//  Created by Denis Garifyanov on 09/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

enum Threads: String {
    case application = "Application"
    case view = "The View"
}
class ThreadLogger {
    private var lastStage: String?
    private let typeOfThread: Threads
    private let states = ["application(_:didFinishLaunchingWithOptions:)":"InAcitve",
                  "applicationDidBecomeActive": "Active",
                  "applicationWillResignActive": "InActive",
                  "applicationDidEnterBackground": "Background",
                  "applicationWillEnterForeground": "InActive",
                  "UIApplicationWillTerminateNotification": "Terminated",
                  "viewDidLoad()": "Loaded",
                  "viewWillAppear": "Appearing",
                  "viewWillLayoutSubviews()": "Layouting",
                  "viewDidLayoutSubviews()": "Layouted",
                  "viewDidAppear": "Appeared",
                  "viewWillDisappear": "Disappearing",
                  "viewDidDisappear": "Disappeared"]
    init(typeOfThread: Threads) {
        self.typeOfThread = typeOfThread
    }
    
    func printStep(byFunction function: String = #function) {
        #if DEBUG
        let method = self.states[function]
        guard let step = method else {
            print ("Unknown state by: \(function)")
            return
        }
        if let lastStage = lastStage {
            print ("\(self.typeOfThread.rawValue) moved from \(lastStage) to \(step): \(function)")
        } else {
            print ("\(self.typeOfThread.rawValue) begin work from \(step): \(function)")
        }
        self.lastStage = step
        #endif
    }
}
