//
//  Chat.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 08.02.17.
//  Copyright © 2017 Sergey Bill. All rights reserved.
//

import Foundation
import SendBirdSDK

class Chat {
    
    static let sharedInstance = Chat()
    var connected = false
    private var channels: [ChatChannel]?
    
    func connect(user: User, completion: @escaping (Bool) -> ()) {
        
        SBDMain.connect(withUserId: user.userID) { (userObj, error) in
            
            SBDMain.updateCurrentUserInfo(withNickname: user.name , profileUrl: user.photo , completionHandler: { (error) in
                
                let connected = error == nil ? true : false
                self.connected = connected
                DispatchQueue.main.async {
                    completion(connected)
                }
            })
        }
    }

    func disconnect(completion: @escaping () -> ()) {
        SBDMain.disconnect {
            completion()
        }
    }

    func createChannel(with user: User, completion: @escaping (Bool, ChatChannel?) -> ()) {
        SBDGroupChannel.createChannel(withName: user.name, isDistinct: true, userIds: [user.userID], coverUrl: nil, data: nil) { (sbdChannel, error) in
            guard let groupChannel = sbdChannel else {completion(false, nil); return}
            let channel = ChatChannel(name: groupChannel.name, channel: groupChannel)
            completion(true, channel)
        }
    }
    
    func requestChannels(completion: @escaping (Bool) -> ()) {
        let query = SBDGroupChannel.createMyGroupChannelListQuery()!
        query.includeEmptyChannel = true
        query.loadNextPage { (channels, error) in
            guard let channels = channels else {
                completion(false)
                return }
            
            self.channels = [ChatChannel]()
            for channel in channels {
                let chatChannel = ChatChannel(name: channel.name, channel: channel)
                self.channels?.append(chatChannel)
            }
            
            completion(true)
        }
    }
    
    func leaveChannel(at index: Int) {
        let channel = self.channels!.remove(at: index)
        channel.leave { (_) in }
    }
    
    func channelsCount() -> Int {
        return self.channels?.count ?? 0
    }
    
    func channel(at index: Int) -> ChatChannel {
        return self.channels![index]
    }
}
