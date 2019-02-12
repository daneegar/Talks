//
//  ViewController.swift
//  Talks
//
//  Created by Denis Garifyanov on 09/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let threadLogger = ThreadLogger(typeOfThread: .view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.threadLogger.printStep()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.threadLogger.printStep()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.threadLogger.printStep()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.threadLogger.printStep()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.threadLogger.printStep()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.threadLogger.printStep()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.threadLogger.printStep()
    }
    

}

