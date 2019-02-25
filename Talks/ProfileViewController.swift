//
//  ViewController.swift
//  Talks
//
//  Created by Denis Garifyanov on 09/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import UIKit
protocol TakeImageDelegate {
    func pickTaken(image takenImage: UIImage)
}
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TakeImageDelegate {
    let threadLogger = ThreadLogger(typeOfThread: .view)
    let cameraHandler = CameraHandler()
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var iconAddPhoto: UIView!
    
    
    
    
    @IBAction func addPhoto(_ sender: Any) {
        print("Выбери изображение профиля")
        self.cameraHandler.showActionSheet(vc: self)
    }

    
    
    //MARK: - переопределенный конструктор
    required init?(coder aDecoder: NSCoder) {
        print(self.buttonEdit?.frame ?? "There is no button yet")
        super.init(coder: aDecoder)
        
    }
    
    //MARK: - методы вызываемые в жизненом цикле вью
    override func viewDidLoad() {
        self.threadLogger.printStep()
        super.viewDidLoad()
        print("The button frame is: \(self.buttonEdit.frame)")
        self.setupButton()
        self.setupProfilePhotoImageAndAddButton()
        let gestureRecognaizer = UISwipeGestureRecognizer(target: self, action: #selector (handleGesture))
        gestureRecognaizer.direction = .down
        self.view.addGestureRecognizer(gestureRecognaizer)
    }
    @objc func handleGesture() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.threadLogger.printStep()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.threadLogger.printStep()
        print("The button frame is: \(self.buttonEdit.frame)")
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
    //MARK: - functions to setup View
    private func setupButton() {
        self.buttonEdit.backgroundColor = .white
        self.buttonEdit.layer.borderColor = UIColor(named: "black")?.cgColor
        self.buttonEdit.layer.borderWidth = 1
        self.buttonEdit.layer.cornerRadius = 10
    }
    private func setupProfilePhotoImageAndAddButton() {
        self.profilePhoto.layer.cornerRadius = 40
        self.iconAddPhoto.layer.cornerRadius = 40
    }
    //MARK: - image pinner
    func pickTaken(image takenImage: UIImage) {
        self.profilePhoto.image = takenImage
    }
    
}

