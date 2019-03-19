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
    @IBOutlet weak var textMessageView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    var keyboardIsShown = false
    @IBAction func sendButtonPressed(_ sender: Any) {
        self.sendAnMessage()
    }
    
    var communicator: CommunicationManager?

    
    @IBOutlet weak var converstaionTableView: UITableView!
    
    var userID: User?
    
    
    var conversation: [Message] = []
    
    
    
    override func viewDidLoad() {
        self.converstaionTableView.register(UINib(nibName: "IncomingMessagCell", bundle: nil), forCellReuseIdentifier: MessageType.inComingMessage.rawValue)
        super.viewDidLoad()
        self.communicator?.delegate = self
        self.converstaionTableView.register(UINib(nibName: "OutGoingMessageCell", bundle: nil),
                                            forCellReuseIdentifier: MessageType.outGoingMessage.rawValue)
        
        self.title = userID?.userID
        
        self.textMessageView.isScrollEnabled = false
        self.textMessageView.textContainer.heightTracksTextView = true
        self.textMessageView.endFloatingCursor()
        
        self.textMessageView.textColor = UIColor.lightGray
        self.textMessageView.selectedTextRange = textMessageView.textRange(from: textMessageView.beginningOfDocument, to: textMessageView.beginningOfDocument)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        guard let userID = self.userID else {return 0}
        if let findedUser = self.communicator?.findUser(byDisplayName: userID.userName){
            return (findedUser.chat.message.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userID = self.userID else {return UITableViewCell()}
        
        if let findedUser = self.communicator?.findUser(byDisplayName: userID.userName){
            let currentMessage = findedUser.chat.message[indexPath.row]
            guard let cell = self.converstaionTableView.dequeueReusableCell(withIdentifier: currentMessage.typeOfMessage.rawValue) as? MessageCell
                else {return UITableViewCell()}
            cell.setupCell(whithText: currentMessage.text, andTypeOf: currentMessage.typeOfMessage)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ConversationViewController: CommunicatorViewControllerDelegate {
    func communicationManagerRecieveMessage(forUser: User) {
        DispatchQueue.main.async {
            self.converstaionTableView.reloadData()
        }
    }
    
    func communicationManagerFoundNewUser() {
        
    }
    
    func sendAnMessage(){
        let message = Message(messageID: generateMessageId(), text: self.textMessageView.text, typeOfMessage: .outGoingMessage)
        textMessageView.text = ""
        guard let userID = self.userID else {return}
        if let index = self.communicator!.listOfPeers.index(of: userID){
            self.communicator!.listOfPeers[index].chat.addMessage(message: message)
            self.converstaionTableView.reloadData()
            let parent = self.navigationController?.children[0] as! ConversationListViewController
            parent.tableViewOfChats.reloadData()
        }
        self.communicator?.communicator.sendMessage(string: message, to: userID.userID, complitionHandler: nil)
    }
    
    func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
            .data(using: .utf8)!.base64EncodedString()
    }
    
}

extension ConversationViewController{
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardIsShown {return} else {keyboardIsShown = !keyboardIsShown}
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant += keyboardSize.height
            UIView.animate(withDuration: 0.4) {
                self.mainView.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if !keyboardIsShown {return} else {keyboardIsShown = !keyboardIsShown}
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant -= keyboardSize.height
            UIView.animate(withDuration: 0.4) {
                self.mainView.layoutIfNeeded()
            }
        }
    }
}

extension ConversationViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        self.textViewHeight.constant = estimatedSize.height
        UIView.animate(withDuration: 0.1) {
            self.mainView.layoutIfNeeded()
            self.converstaionTableView.layoutIfNeeded()
        }
    }
}

