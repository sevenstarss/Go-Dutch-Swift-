//
//  Session.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 05.12.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation

class Session {
    
    static let sharedInstance = Session()
    private var currentUserPrimitive: User?
    var currentUser: User? {
        get {
            guard let user = self.currentUserPrimitive else {
                
                if let userObj = UserDefaults.standard.object(forKey: "Current_User") as? [String: AnyObject] {
                    
                    let user = User(dictionary: userObj)
                    return user
                    
                } else {
                    return nil
                }
            }
            
            return user
        }
        
        set {
            
            guard let user = newValue else { return }
            self.currentUserPrimitive = user
            let userObj = user.serialize()
            UserDefaults.standard.set(userObj, forKey: "Current_User")
        }
    }
    
}
