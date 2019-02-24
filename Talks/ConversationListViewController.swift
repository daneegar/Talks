//
//  ChatsTableView.swift
//  Talks
//
//  Created by Denis Garifyanov on 20/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation
import UIKit

class ConversationListViewController: UIViewController {
    
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
        for _ in 0...31 {
            self.listOfChats.append(Chat(name: RandomData.randomString(length: 10), message: RandomData.randomString(length: 10), date: Date(), onlineStatus: RandomData.randomBool(), hasUnreadMessages: RandomData.randomBool()))
        }
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
