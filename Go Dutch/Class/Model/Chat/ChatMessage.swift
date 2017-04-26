//
//  ChatMessage.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 10.02.17.
//  Copyright © 2017 Sergey Bill. All rights reserved.
//

import Foundation
import SendBirdSDK

class ChatMessage {
    
    let text: String
    let date: Date
    let senderID: String
    let senderName: String
    private let user: SBDUser
    
    init(text: String, user: SBDUser, date: Int64) {
        self.text = text
        self.user = user
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(date))
        self.senderID = user.userId
        self.senderName = user.nickname ?? ""
    }
    
    func isIncomming() -> Bool {
        return Session.sharedInstance.currentUser?.userID ?? "" == self.user.userId
    }
}
