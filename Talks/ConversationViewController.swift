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

class ConversationViewController: UIViewController, MCNearbyServiceBrowserDelegate {
    
    private let serviceType = "tinkoff-chat"
    //private let discoveryInfo: [String: String]?
    var peers: [MCPeerID] = []
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    
    private let myPeerId = MCPeerID(displayName: "denis")
    private var serviceAdvertiser: MCNearbyServiceAdvertiser?
    private var serviceBrowser: MCNearbyServiceBrowser?
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print(#function)
        
        print(peerID)
        print(browser)
        
        if !self.peers.contains(peerID){self.peers.append(peerID)}
        
        browser.invitePeer(peerID, to: self.session, withContext: nil , timeout: 10)
    }
    
    
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(#function)
        print(peerID)
        print(browser)
    }
    
    
    
    
    @IBOutlet weak var converstaionTableView: UITableView!
    var conversation: [Message] = []
    
    override func viewDidLoad() {
        self.converstaionTableView.register(UINib(nibName: "IncomingMessagCell", bundle: nil), forCellReuseIdentifier: MessageType.inComingMessage.rawValue)
        super.viewDidLoad()
        
       self.converstaionTableView.register(UINib(nibName: "OutGoingMessageCell", bundle: nil), forCellReuseIdentifier: MessageType.outGoingMessage.rawValue)
        
        self.richConversation()
        self.converstaionTableView.reloadData()
        
        
//        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.myPeerId, discoveryInfo: nil, serviceType: self.serviceType)
//        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.myPeerId, serviceType: self.serviceType)
        self.serviceAdvertiser?.delegate = self
        self.serviceBrowser?.delegate = self
        self.serviceAdvertiser?.startAdvertisingPeer()
        self.serviceBrowser?.startBrowsingForPeers()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func send(data:Data) {
        NSLog("%@", "sendColor: \(data) to \(session.connectedPeers.count) peers")
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
    }
    
    func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
            .data(using: .utf8)!.base64EncodedString()
    }
}

extension ConversationViewController: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate
{

    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    }
    
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //print(#function)
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
}
