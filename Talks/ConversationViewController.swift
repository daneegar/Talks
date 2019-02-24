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

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var converstaionTableView: UITableView!
    var conversation: [Message] = []
    
    override func viewDidLoad() {
        self.converstaionTableView.register(UINib(nibName: "IncomingMessagCell", bundle: nil), forCellReuseIdentifier: MessageType.inComingMessage.rawValue)
        super.viewDidLoad()
        
       self.converstaionTableView.register(UINib(nibName: "OutGoingMessageCell", bundle: nil), forCellReuseIdentifier: MessageType.outGoingMessage.rawValue)
        self.richConversation()
        self.converstaionTableView.reloadData()
    }
    //MARK: - lets test ConversationViewController
    func richConversation(){
        for _ in 0...3 {
            self.conversation.append(Message(text: RandomData.randomString(length: 50), typeOfMessage: .inComingMessage))
            self.conversation.append(Message(text: RandomData.randomString(length: 30), typeOfMessage: .outGoingMessage))
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
}
