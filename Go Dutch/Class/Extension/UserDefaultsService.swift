//  Copyright (c) 2015 Cheering & Chanting AB. All rights reserved.

import Foundation

class UserDefaultsService: NSObject {
    class func saveUser(_ user: UserModel?) {
        if let user = user {
            let defaults: UserDefaults = UserDefaults.standard
            
            defaults.set(user.userid, forKey: "userid")
            defaults.set(user.name, forKey: "name")
            defaults.set(user.email, forKey: "email")
            defaults.set(user.phone, forKey: "phone")
            defaults.set(user.location, forKey: "location")
            defaults.set(user.photourl, forKey: "photourl")
            defaults.set(user.birthday, forKey: "birthday")
            defaults.set(user.verifyStatus, forKey: "verifyStatus")

            _ = defaults.synchronize()
        }
    }

    class func loadUser() -> UserModel? {
        let defaults: UserDefaults = UserDefaults.standard
        
        var userid : String!
        var name : String!
        var email : String!
        var phone : String!
        var location : String!
        var photourl : String!
        var birthday : String!
        
        var verifyStatus : Bool = false
        
        
        if let defaultName = defaults.object(forKey: "userid") as? String {
            userid = defaultName
        }
        
        if let defaultToken = defaults.object(forKey: "name") as? String {
            name = defaultToken
        }
        
        if let defaultSelectedTeam = defaults.value(forKey: "email") as? String! {
            email = defaultSelectedTeam
        }

        if let defaultSelectedTeam = defaults.value(forKey: "phone") as? String! {
            phone = defaultSelectedTeam
        }

        if let defaultSelectedTeam = defaults.value(forKey: "location") as? String! {
            location = defaultSelectedTeam
        }

        if let defaultSelectedTeam = defaults.value(forKey: "photourl") as? String! {
            photourl = defaultSelectedTeam
        }

        if let defaultSelectedTeam = defaults.value(forKey: "birthday") as? String! {
            birthday = defaultSelectedTeam
        }

        if let defaultSelectedTeam = defaults.value(forKey: "verifyStatus") as? Bool! {
            
            if defaultSelectedTeam != nil
            {
                verifyStatus = defaultSelectedTeam
            }
        }

        
        if (userid != nil)
        {
            var dictionary: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()

            dictionary["userid"] = userid as AnyObject?
            dictionary["name"] = name as AnyObject?
            dictionary["email"] = email as AnyObject?
            dictionary["phone"] = phone as AnyObject?
            dictionary["location"] = location as AnyObject?
            dictionary["photourl"] = photourl as AnyObject?
            dictionary["birthday"] = birthday as AnyObject?
            dictionary["verifyStatus"] = verifyStatus as AnyObject?

            return UserModel(dict: dictionary as NSDictionary)
        }
        
        return nil;
    }
    
    
    class func deleteUser() {
        let appDomain: NSString = Bundle.main.bundleIdentifier! as NSString
        UserDefaults.standard.removePersistentDomain(forName: appDomain as String)
        
//        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//
//        defaults.removeObjectForKey("userid")
//        defaults.removeObjectForKey("firstname")
//        defaults.removeObjectForKey("lastname")
//        defaults.removeObjectForKey("username")
//        defaults.removeObjectForKey("email")
//        defaults.removeObjectForKey("verified")
//        
//        _ = defaults.synchronize()

    }

}
