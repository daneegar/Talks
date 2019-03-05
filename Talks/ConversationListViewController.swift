//
//  ChatsTableView.swift
//  Talks
//
//  Created by Denis Garifyanov on 20/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation
import UIKit

@objc class ConversationListViewController: UIViewController, ThemesChangeLogger {
    let logger = ThreadLogger(typeOfThread: .view)
    
    @IBOutlet weak var tableViewOfChats: UITableView!
    var listOfChats: [Chat] = []
    //README: :- я понимаю что такой способо организации двух списков довольно затратный, но сделаю рефакторинг когда будет понятно откуда и как эти данные будут браться, на данный момент вижу как двумерный массив. Протестировал на двух тысячах чатах, все скролится ок.
    var listOfOnlineOpponents: [Chat] {
        get {
            var result: [Chat] = []
            for chat in listOfChats {
                if chat.online {result.append(chat)}
            }
            return result
        }
    }
    var listOfflineOpponents: [Chat] {
        get {
                var result: [Chat] = []
                for chat in listOfChats {
                    if !chat.online {result.append(chat)}
                }
                return result
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOfChats.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        self.richList()
        self.tableViewOfChats.reloadData()
        self.navigationItem.title = "Tinkoff Chat"
    }
    //MARK: - lets test our TableView with Cells
    private func richList() {
        print("Тестовое наполнение списка чатов, все заполняется случайным образом, случайная дата выбирается в диапазоне с десяти суток назад по настоящий момент")
        for _ in 0...31 {
            self.listOfChats.append(Chat(name: RandomData.randomString(length: 10), message: RandomData.randomString(length: 10), date: RandomData.generateRandomDate(daysBack: 10), onlineStatus: RandomData.randomBool(), hasUnreadMessages: RandomData.randomBool()))
        }
    }
    
    func logThemeChanging(selectedTheme: UIColor){
        print("theme has been changed!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat" {
            //print(segue.identifier)
            guard let selectedIndexPath = self.tableViewOfChats.indexPathForSelectedRow else {return}
            if selectedIndexPath.section == 0 {
                segue.destination.title =  self.listOfOnlineOpponents[selectedIndexPath.row].name
            } else {
                segue.destination.title = self.listOfflineOpponents[selectedIndexPath.row].name
            }
        }
        if segue.identifier == "showThemeaView" {
            let navigationVC = segue.destination as! UINavigationController
            print("to \(segue.destination)")
            guard let targetViewController = navigationVC.viewControllers[0] as? ThemesViewContoller else {return}
            targetViewController.delegate = self;
        }
    }
    //MARK: - actions
    @IBAction func configButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showThemeaView", sender: nil)
    }
    
}





//MARK: - TableView methods
extension ConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.listOfOnlineOpponents.count
        } else {
            return self.listOfflineOpponents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = self.tableViewOfChats.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        if section == 0 {
            cell.configProperies(withChatModel: self.listOfOnlineOpponents[indexPath.row])
        } else {
            cell.configProperies(withChatModel: self.listOfflineOpponents[indexPath.row])
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "Offline"
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toChat", sender: nil)
    }
    
}
