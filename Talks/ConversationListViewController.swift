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
    var communicator: CommunicationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCommunicator()
        self.tableViewOfChats.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        self.tableViewOfChats.reloadData()
        self.navigationItem.title = "Tinkoff Chat"
        
    }
    //MARK: - lets test our TableView with Cells
    private func richList() {
    }
    
    func logThemeChanging(selectedTheme: UIColor){
        print("theme has been changed!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat" {
            //print(segue.identifier)
            guard let selectedIndexPath = self.tableViewOfChats.indexPathForSelectedRow else {return}
            if selectedIndexPath.section == 0 {
                segue.destination.title =  "done with it"
            } else {
                segue.destination.title = "done with it"
            }
            let destinataion = segue.destination as! ConversationViewController
            destinataion.communicator = self.communicator
        }
        if segue.identifier == "showThemeaView" {
            let _ = segue.destination as! UINavigationController
            
        }
    }
    //MARK: - actions
    @IBAction func configButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showThemeaView", sender: nil)
    }
    
    func configCommunicator(){
        let loader = DataStoreGCD()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("UserProfile.plist")
        let userProfile = UserProfile()
        loader.loadData(inPath: dataFilePath!, forModel: userProfile, completion: { (data, error) in
            DispatchQueue.main.async {
                if let userProfile = data {
                    self.communicator = CommunicationManager(delegate: self, peerID: userProfile.name!)
                } else {
                    self.communicator = CommunicationManager(delegate: self, peerID: "default")
                }
            }
        })
    }
    
}

//MARK: - TableView methods
extension ConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let counted = self.communicator?.listOfPeers.count else {return 0}
        return counted
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewOfChats.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        cell.configProperies(withChatModel: (communicator?.listOfPeers[indexPath.row])!)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

extension ConversationListViewController: CommunicatorViewControllerDelegate{
    func communicationManagerFoundNewUser() {
        DispatchQueue.main.async {
            self.tableViewOfChats.reloadData()
        }
    }
    
    func communicationManagerRecieveMessage(forUser: User) {
        
    }
    
    
}
