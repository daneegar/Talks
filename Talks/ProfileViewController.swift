//
//  ViewController.swift
//  Talks
//
//  Created by Denis Garifyanov on 09/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let threadLogger = ThreadLogger(typeOfThread: .view)
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var iconAddPhoto: UIView!
    
    
    @IBAction func addPhoto(_ sender: Any) {
        print("Выбери изображение профиля")
    }

    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        print("init nibName style")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        print(self.buttonEdit?.frame ?? "There is no button yet")
        //TODO: - объяснить в чем проблема:
        //Если обращаться к свойству экземпляра класса в конструкторе, то нужно понимать когда это конкретное свойство инициализируется.
        //в случае с атулетами, они по умолчанию weak, эти сслыки удерживаются иерархией вью, видимо, когда класс вью инициализируется он еще не встроен в иерархию, отсюда и отсутсвие ссылки на объект.
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        self.threadLogger.printStep()
        super.viewDidLoad()
        print("The button frame is: \(self.buttonEdit.frame)")
        self.setupButton()
        self.setupProfilePhotoImageAndAddButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.threadLogger.printStep()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.threadLogger.printStep()
        print("The button frame is: \(self.buttonEdit.frame)")
        //TODO: - так как сториборд мы верстаем в превью iPhone SE то в первом приближении устанавливаются значения Frame исходя из того как и где верстали, при включении в иерархию вьюшек применяются консстрейны и исходя из них перерасчитываются параметры frame свойста кнопки.
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
    

}

