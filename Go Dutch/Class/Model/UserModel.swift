//
//  UserModel.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/13/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    var userid : String!
    var name : String?
    var email : String?
    var phone : String?
    var location : String?
    var photourl : String?
    var birthday : String?
    
    var verifyStatus : Bool = false
    
    override init() {
        super.init()
    }
    
    init(dict : NSDictionary) {
        
        super.init()
        
        self.userid = String(describing: (dict["userid"])!)
        
        self.name = dict["name"] as? String
        self.email = dict["email"] as? String
        self.phone = dict["phone"] != nil ? String(describing: (dict["phone"])!) : ""
        self.location = dict["location"] as? String
        self.location = dict["location"] as? String
        self.photourl = dict["photourl"] as? String
        self.birthday = dict["birthday"] as? String
        
        if let val = dict["verifyStatus"]
        {
            self.verifyStatus = val as! Bool
            
        }

        
    }
    
}
