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
    
    var userProfile: UserProfile?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("UserProfile.plist")
    let defaults = UserDefaults.standard
    var dataStoreLoadDHandler: DataAsyncStoreProtocol?
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    let okAllert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
    enum queueMethods {
        case GCD
        case operations
    }
    
    let animationQueue = DispatchQueue(label: "concurrency.UIanimating.serial")
    
    private var editingModeOn = false
    
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
    
    @IBOutlet weak var heightOfProfilePhotoView: NSLayoutConstraint!
    @IBOutlet weak var constraintContenViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttinViewBottom: NSLayoutConstraint!
    
    
    
    
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
        
        self.dataStoreLoadDHandler = DataStoreGCD()
        self.saveData()
    }
    
    @IBAction func operationButtonPressed(_ sender: Any) {
        self.dataStoreLoadDHandler = DataStoreOperation()
        self.saveData()
    }
    
    
    //MARK: - методы вызываемые в жизненом цикле вью
    override func viewDidLoad() {
        self.contentScrollView.flashScrollIndicators()
        self.setupDelegates()
        self.threadLogger.printStep()
        self.disableEditingMode()
        self.addObserveToKeyboard()
        self.setupActivityIndicator()
        self.setupAllerts()
        self.loadData()
        
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
        //self.threadLogger.printStep()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.threadLogger.printStep()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.threadLogger.printStep()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.threadLogger.printStep()
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
    
    private func setupActivityIndicator()
    {
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
    }
    
    private func setupAllerts()
    {
        self.okAllert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    private func setupDelegates()
    {
        self.nameTextField.delegate = self
        self.aboutTextView.delegate = self
        self.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - image pinner
    func pickTaken(image takenImage: UIImage) {
        self.profilePhoto.image = takenImage
        self.checkProfileIsEdited()
    }
    
    //MARK: - save load data methods
    func loadData(){
        self.activityIndicator.startAnimating()
        self.dataStoreLoadDHandler = DataStoreGCD()
        self.dataStoreLoadDHandler?.loadData(inPath: self.dataFilePath!, forModel: self.userProfile, completion: { (data, error) in
            DispatchQueue.main.async {
                if let userProfile = data {
                    self.userProfile = userProfile
                    self.profilePhoto.image = self.userProfile?.avatar
                    self.aboutTextView.text = self.userProfile?.aboutInformation
                    self.nameTextField.text = self.userProfile?.name
                }
                self.activityIndicator.stopAnimating()
                self.saveButtons(makeEnable: false)
            }
        })
    }
    
    func saveData()
    {
        self.userProfile = UserProfile(name: self.nameTextField.text!, aboutInfirmation: self.aboutTextView.text, avatar: self.profilePhoto.image!)
        self.activityIndicator.startAnimating()
        self.saveButtons(makeEnable: false)
        self.dataStoreLoadDHandler?.storeData(data: self.userProfile, inPath: self.dataFilePath!, forKey: "UserProfile.plist") { (error) in
            DispatchQueue.main.async{
                if let error = error {
                    print(error)
                    self.okAllert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (allertAction) in
                        self.saveData()
                    }))
                }
                self.activityIndicator.stopAnimating()
                self.present(self.okAllert, animated: true)
            }
        }
    }
    
    
}
// MARK: - editing mode handlers
extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        self.checkProfileIsEdited()
    }
        
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.checkProfileIsEdited()
    }
    
    func disableEditingMode(){
        self.aboutTextView.isEditable = false
        self.aboutTextView.textColor = UIColor(rgb: 0xD3D3D3, alpha: 1.0)
        self.nameTextField.isEnabled = false
        self.nameTextField.textColor = UIColor(rgb: 0xD3D3D3, alpha: 1.0)
        self.iconAddPhoto.isHidden = true
    }
    func switchEditingMode(){
        self.editingModeOn = !self.editingModeOn
        UIView.animate(withDuration: 0.3, animations: {
            self.aboutTextView.isEditable = self.editingModeOn
            self.aboutTextView.textColor = self.editingModeOn ? .black : UIColor(rgb: 0xD3D3D3, alpha: 1.0)
            self.nameTextField.isEnabled = self.editingModeOn
            self.nameTextField.textColor = self.editingModeOn ? .black : UIColor(rgb: 0xD3D3D3, alpha: 1.0)
            self.iconAddPhoto.isHidden = !self.editingModeOn
            self.contentView.layoutIfNeeded()
        }, completion: nil)
    }
    //MARK: - проверка что пользователь что-то изменил. Я реализовал хранение данных через модель UserProfile и ума не приложу как вносить изменения только изменившегося свойства
    // если я использую протокол codeble у меня не получилось переопределить метод encode что бы изменять только часть данных.
    func checkProfileIsEdited(){
        if (self.userProfile?.avatar != self.profilePhoto.image || self.userProfile?.name != self.nameTextField.text || self.userProfile?.aboutInformation != self.aboutTextView.text) {
            self.saveButtons(makeEnable: true)
        } else {
            self.saveButtons(makeEnable: false)
        }
    }
    func saveButtons(makeEnable enableStatus: Bool){
        self.buttonGCD.isEnabled = enableStatus
        self.buttonOperation.isEnabled = enableStatus
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
 
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print(self.contentView.frame)
            animationQueue.sync(flags: .barrier) {
                if self.buttinViewBottom.constant == 8{
                    self.letsChangeConstraintsWhenKeyboardHideAndShow(isHide: false)
                }
            }
        }
    }
    @objc func keyboardWillHied(notification: NSNotification) {
        animationQueue.sync {
            if self.buttinViewBottom.constant != 8{
                self.letsChangeConstraintsWhenKeyboardHideAndShow(isHide: true)
            }
        }
        print(self.contentView.frame)
    }
    func letsChangeConstraintsWhenKeyboardHideAndShow(isHide: Bool){
        UIView.animate(withDuration: 0.3, animations: {
            print(UIDevice.current.model)
            self.constraintContenViewHeight.constant = isHide ? self.constraintContenViewHeight.constant - self.keyboardHeight : self.constraintContenViewHeight.constant + self.keyboardHeight
            print(self.buttinViewBottom.constant)
            self.buttinViewBottom.constant =  isHide ? 8 : self.buttinViewBottom.constant + self.keyboardHeight
            print(self.buttinViewBottom.constant)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func endEditing()
    {
        self.aboutTextView.endEditing(true)
        self.nameTextField.endEditing(true)
    }
}

