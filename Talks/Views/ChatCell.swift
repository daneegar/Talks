//
//  ChatCell.swift
//  Talks
//
//  Created by Denis Garifyanov on 21/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell, ConversationCellConfiguration {
    var name: String?
    var message: String?
    var date: Date?
    //TODO: - you should to do smth with its default constants.
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastText: UILabel!
    @IBOutlet weak var lastDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configProperies(withChatModel instance: Chat) {
        self.name = instance.name
        self.message = instance.message
        self.date = instance.date
        self.online = instance.online
        self.hasUnreadMessages = instance.hasUnreadMessages
        self.configCellView()
    }
    
    func configCellView() {
        self.nameLabel.text = name
        if let message = self.message {
            self.lastText.text = message
        } else {
            self.lastText.text = "No messages yet"
            self.lastText.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        
        if self.hasUnreadMessages {
            self.lastText.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        
        let datesHandler = DatesHandler()
        
        self.lastDateLabel.text = datesHandler.stringWithChoisedFromatter(withDate: self.date!, howManyDatesIsNotCorrent: 0)
        self.backgroundColor = self.online ? UIColor(rgb: 0xDBE5C6, alpha: 0.3) : UIColor.white
    }
    
}
