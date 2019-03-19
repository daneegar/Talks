//
//  ConversationViewController.swift
//  Talks
//
//  Created by Denis Garifyanov on 22/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//
enum MessageType: String {
    case inComingMessage = "inComingMessageCell"
    case outGoingMessage = "outGoingMessageCell"
}

import UIKit
import MultipeerConnectivity

class ConversationViewController: UIViewController{
    
    
    var communicator: CommunicationManager?

    
    @IBOutlet weak var converstaionTableView: UITableView!
    var conversation: [Message] = []
    
    override func viewDidLoad() {
        self.converstaionTableView.register(UINib(nibName: "IncomingMessagCell", bundle: nil), forCellReuseIdentifier: MessageType.inComingMessage.rawValue)
        super.viewDidLoad()
        self.communicator?.delegate = self
        self.converstaionTableView.register(UINib(nibName: "OutGoingMessageCell", bundle: nil), forCellReuseIdentifier: MessageType.outGoingMessage.rawValue)
        self.converstaionTableView.reloadData()
    }
    //MARK: - lets test ConversationViewController
    func richConversation(){
        for _ in 0...3 {
            self.conversation.append(Message(messageID: "undefined", text: RandomData.randomString(length: 50), typeOfMessage: .inComingMessage))
            self.conversation.append(Message(messageID: "undefined", text: RandomData.randomString(length: 30), typeOfMessage: .outGoingMessage))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            let parentViewControoler = self.parent?.children[0] as! ConversationListViewController
            parentViewControoler.communicator?.delegate = parentViewControoler
        }
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = conversation[indexPath.row]
        guard let cell = self.converstaionTableView.dequeueReusableCell(withIdentifier: currentMessage.typeOfMessage.rawValue) as? MessageCell
            else {
            return UITableViewCell()
        }
        cell.setupCell(whithText: currentMessage.text, andTypeOf: currentMessage.typeOfMessage)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ConversationViewController: CommunicatorViewControllerDelegate {
    func communicationManagerRecieveMessage(forUser: User) {
        print(forUser.userID)
    }
    
    func communicationManagerFoundNewUser() {
        
    }
    
}

