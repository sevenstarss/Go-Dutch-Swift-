//
//  User.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 20.10.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation

class User {
    
    var userID: String!
    var photo: String?
    var name: String!
    var location: String!
    var likeDate: Date?
    var userDescription: String!
    var phone = ""
    var verifyStatus = false
    
    init(dictionary: [String: AnyObject]) {
        
        let userID = dictionary["cip_userid"] as! String
        self.userID = userID
        if let photo = dictionary["ci_photourl"] as? String {
            self.photo = photo
        }
        if let name = dictionary["ci_name"] as? String {
            self.name = name
        }
        if let location = dictionary["ci_location"] as? String {
            self.location = location
        }
        
        if let userDescription = dictionary["description"] as? String {
            self.userDescription = userDescription
        }
        
        if let verifyStatus = dictionary["verify_status"] as? String {
            self.verifyStatus = verifyStatus == "true" ? true : false
        }
        
        if let phone = dictionary["ci_phone"] as? String {
            self.phone = phone
        }
        
        guard let likeDate = dictionary["event_like_dt"] as? String else { return }
        guard let date = self.dateFrom(string: likeDate) else { return }
        self.likeDate = date
    }
    
    init(userModel: UserModel) {
        
        self.userID = userModel.userid
        self.photo = userModel.photourl
        self.name = userModel.name
        self.location = userModel.location
        self.verifyStatus = userModel.verifyStatus
    }
    
    func serialize() -> [String: String] {
        
        var userObj = [String: String]()
        
        userObj["cip_userid"] = self.userID
        userObj["ci_photourl"] = self.photo
        userObj["ci_name"] = self.name
        userObj["ci_location"] = self.location
        userObj["ci_description"] = self.userDescription
        userObj["verify_status"] = self.verifyStatus ? "true" : "false"
        userObj["ci_phone"] = self.phone
        userObj["description"] = self.userDescription
        
        
        guard let likeDate = self.likeDate else { return userObj }
        let likeDateString = self.stringFrom(date: likeDate)
        userObj["event_like_dt"] = likeDateString
        
        return userObj
    }
    
    private func stringFrom(date: Date) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        
        return dateString
    }
    
    private func dateFrom(string: String) -> Date? {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = df.date(from: string) else { return nil }
        
        return date
    }
}
