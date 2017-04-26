//
//  ChatChannel.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 09.02.17.
//  Copyright © 2017 Sergey Bill. All rights reserved.
//

import Foundation
import SendBirdSDK

protocol ChatChannelDelegate {
    func chatChannelDidRecieveMessage(message: ChatMessage)
}

class ChatChannel: NSObject, SBDChannelDelegate {
    
    var name: String
    var delegate: ChatChannelDelegate?
    private var messages = [ChatMessage]()
    var channelObj: SBDGroupChannel
    private let batchSize = 30
    private var messageQuery: SBDPreviousMessageListQuery?
    
    deinit {
        
    }
    
    init(name: String, channel: SBDGroupChannel) {
        self.name = name
        self.channelObj = channel
        super.init()
        SBDMain.add(self, identifier: name+"_CHANNEL_DELEGATEID")
    }
    
    func leave(completion: @escaping (Bool) -> ()) {
        self.channelObj.leave { (error) in
            let completed = error == nil ? true : false
            completion(completed)
        }
    }
    
    func sendMessage(message: String, completion: @escaping (Bool) -> ()) {
        self.channelObj.sendUserMessage(message) { (message, error) in
            let sent = error == nil ? true : false
            completion(sent)
        }
    }
    
    func requestPreviousMessages(completion: @escaping () -> ()) {
        if self.messageQuery == nil {
            self.messageQuery = self.channelObj.createPreviousMessageListQuery()!
        }
        
        self.messageQuery!.loadPreviousMessages(withLimit: self.batchSize, reverse: false) { (messages, error) in
            guard let channelMessages = messages else { completion() ; return }
            for message in channelMessages {
                self.appendMessage(message: message)
            }
            completion()
        }
    }
    
    func messagesCount() -> Int {
        return self.messages.count
    }
    
    func chatMessage(at index: Int) -> ChatMessage {
        return self.messages[index]
    }
    
    //MARK: - SBDChannelDelegate
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        self.appendMessage(message: message)
        self.delegate?.chatChannelDidRecieveMessage(message: self.messages.last!)
    }
    
    //MARK: - Private
    
    private func appendMessage(message: SBDBaseMessage) {
        guard let userMessage = message as? SBDUserMessage else { return }
        let chatMessage = ChatMessage(text: userMessage.message ?? "", user: userMessage.sender!, date: userMessage.createdAt)
        self.messages.append(chatMessage)
    }
}

