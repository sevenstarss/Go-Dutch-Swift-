//
//  Event.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 19.10.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation

class Event {
    
    var eventID: String!
    var title: String!
    var eventDescription: String!
    var location: String!
    var date: String!
    var time: String!
    var cost: String!
    var categoryID: String!
    var categoryName: String!
    var photo: String!
    var isLikedByUser: Bool!
    
    var usersLiked: [User]?
    
    init(dictionary: [String: AnyObject]) {
        
        self.eventID = dictionary["id"] as! String
        self.title = dictionary["event_title"] as! String
        self.eventDescription = dictionary["event_description"] as! String
        self.location = dictionary["event_location"] as! String
        
        self.date = dictionary["event_date"] as! String
        if let date = self.dateFrom(string: self.date) {
            self.date = self.dateStringFrom(date: date)
            self.time = self.timeStringFrom(date: date)
        }
        
        self.cost = dictionary["cost"] as! String
        self.categoryID = dictionary["category_id"] as! String
        self.categoryName = "AAA" //dictionary["category_name"] as! String
        self.photo = Server_ImageURL + (dictionary["photo"] as! String)
        if let isLikedByUser = dictionary["is_liked_by_user"] as? String {
            self.isLikedByUser = isLikedByUser == "1"
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        
        let df = DateFormatter()
        df.dateFormat = "EEEE d MMM"
        
        return df
    }()
    
    lazy var timeFormatter: DateFormatter = {
        
        let tf = DateFormatter()
        tf.dateFormat = "h:mm a"
        
        return tf
    }()
    
    lazy var dateFromStringFormatter: DateFormatter = {
       
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return df
    }()
    
    private func dateStringFrom(date: Date) -> String {
        
        let dateString = self.dateFormatter.string(from: date)
        
        return dateString
    }
    
    private func timeStringFrom(date: Date) -> String {
        
        let timeString = self.timeFormatter.string(from: date)
        
        return timeString
    }
    
    private func dateFrom(string: String) -> Date? {
        
        guard let date = self.dateFromStringFormatter.date(from: string) else { return nil }
        
        return date
    }
}
