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
    var keyboardHeight: CGFloat!
    var activeField: UITextView?

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var buttonsView: UIViewAnimating!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonGCD: UIButton!
    @IBOutlet weak var buttonOperation: UIButton!
    @IBOutlet weak var iconAddPhoto: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!


    @IBOutlet weak var constraintContenViewHeight: NSLayoutConstraint!
    
    
    
    
    @IBAction func addPhoto(_ sender: Any) {
        print("Выбери изображение профиля")
        self.cameraHandler.showActionSheet(vc: self)
    }
    
    @IBAction func editingModeButtonPressed(_ sender: Any){
        self.switchEditingMode()
        
    }
    
    @IBAction func doneButtonPressed (_ sender: Any){
        self.handleGesture()
    }

    @IBAction func gcdButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func operationButtonPressed(_ sender: Any) {
        
    }
    
    //MARK: - переопределенный конструктор
    required init?(coder aDecoder: NSCoder) {
        print(self.buttonEdit?.frame ?? "There is no button yet")
        super.init(coder: aDecoder)
        
    }
    
    //MARK: - методы вызываемые в жизненом цикле вью
    override func viewDidLoad() {
        self.contentScrollView.flashScrollIndicators()
        self.aboutTextView.delegate = self
        self.threadLogger.printStep()
        self.disableEditingMode()
        self.addObserveToKeyboard()
        super.viewDidLoad()
        print("The button frame is: \(self.buttonEdit.frame)")
        self.setupButtons()
        self.setupProfilePhotoImageAndAddButton()
    }
    func handleGesture() {
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
        self.contentScrollView.flashScrollIndicators()
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
    private func setupButtons() {
        self.buttonEdit.backgroundColor = .white
        self.buttonEdit.layer.borderColor = UIColor(named: "black")?.cgColor
        self.buttonEdit.layer.borderWidth = 1
        self.buttonEdit.layer.cornerRadius = 10
        self.buttonGCD.layer.cornerRadius = 10
        self.buttonOperation.layer.cornerRadius = 10
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
// MARK: - editing mode handlers
extension ProfileViewController
{
    func disableEditingMode(){
        self.aboutTextView.isEditable = false
        self.aboutTextView.textColor = UIColor(rgb: 0xD3D3D3, alpha: 1.0)
        self.nameTextField.isEnabled = false
        self.nameTextField.textColor = UIColor(rgb: 0xD3D3D3, alpha: 1.0)
    }
    func switchEditingMode(){
        UIView.animate(withDuration: 1.0) {
            self.aboutTextView.isEditable = !self.aboutTextView.isEditable
            self.aboutTextView.textColor = self.aboutTextView.isEditable ? .black : UIColor(rgb: 0xD3D3D3, alpha: 1.0)
            self.nameTextField.isEnabled = !self.nameTextField.isEnabled
            self.nameTextField.textColor = self.nameTextField.isEnabled ? .black : UIColor(rgb: 0xD3D3D3, alpha: 1.0)
        }
    }
}
// MARK:- keyboard methods and observers
extension ProfileViewController
{
    func addObserveToKeyboard(){
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHied(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContenViewHeight.constant += self.keyboardHeight + 100
            })
        }
    }
    @objc func keyboardWillHied(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintContenViewHeight.constant -= self.keyboardHeight - 100
        }
    }
    @objc func endEditing()
    {
        self.aboutTextView.endEditing(true)
        self.nameTextField.endEditing(true)
    }
}

@objc extension ProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
    }

}

