//
//  ViewController.swift
//  Talks
//
//  Created by Denis Garifyanov on 09/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let lifeShower = LifeCircle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lifeShower.printStep(byFunction: #function, isApplication: false)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lifeShower.printStep(byFunction: #function, isApplication: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lifeShower.printStep(byFunction: #function, isApplication: false)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.lifeShower.printStep(byFunction: #function, isApplication: false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.lifeShower.printStep(byFunction: #function, isApplication: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.lifeShower.printStep(byFunction: #function, isApplication: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lifeShower.printStep(byFunction: #function, isApplication: false)
    }
    

}

