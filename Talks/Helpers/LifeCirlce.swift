//
//  LifeCirlce.swift
//  Talks
//
//  Created by Denis Garifyanov on 09/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class LifeCircle {
    private var lastStage: String?
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
    func printStep(byFunction function: String, isApplication: Bool) {
        let tryToCathcStep = self.states[function]
        let preFix = isApplication ? "Application " : "The View "
        guard let step = tryToCathcStep else {
            print ("Unknown state")
            return
        }
        if let lastStage = lastStage {
            print ("\(preFix)moved from \(lastStage) to \(step): \(function)")
        } else {
            print ("\(preFix)begin work from \(step): \(function)")
        }
        self.lastStage = step
    }
}
