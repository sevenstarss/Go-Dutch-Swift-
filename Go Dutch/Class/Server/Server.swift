//
//  Server.swift
//  BLR Connect
//
//  Created by Michael Pieper on 7/23/16.
//  Copyright © 2016 Michal Pieper. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

open class Server: NSObject
{
    func getPhoneNumber(_ phoneNo : String) -> String {
        
        let phoneNumber = phoneNo.replacingOccurrences(of: "-", with: "")
        
        return PhoneNumberHelper().getMobileCountryCode() + phoneNumber
    }
    
    //MARK: Sign UP
    func registerUser(_ name: String, location: String, birthday: String, email: String, phone: String, photoURL: String, completion : @escaping (_ result : Bool, _ erorCode: Int, _ data : NSDictionary?) -> Void) {
        
        Alamofire.request(Server_Main_Url + Server_UserSignUp, method: .post, parameters: ["name": name, "location": location, "birthday": birthday, "email": email, "phone": self.getPhoneNumber(phone), "photourl": photoURL], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary
            {
                let status = json["status"] as! Int
                
                print(json)
                
                if status == Success_ServerRequest
                {
                    completion(true, status, json)
                }
                else
                {
                    completion(false, status, nil)
                }
            }
            else
            {
                completion(false, ERR_SYSTEM_PARAMTER_NOT_FOUND, nil)
            }
        }
    }
    
    //MARK: Verify User
    func verifyUser(_ phone: String, state: String, completion : @escaping (_ result : Bool, _ data : NSDictionary?) -> Void) {

        Alamofire.request(Server_Main_Url + Server_SetVerify, method: .post, parameters: ["phone": self.getPhoneNumber(phone), "state": state], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary
            {
                if let info = json.allValues.first as? NSDictionary {
                    completion(true, info)
                } else {
                    completion(false, nil)
                }
                
            }
            else
            {
                completion(false, nil)
            }
        }
    }
    
    //MARK: Log In User
    func signinUser(_ email: String, phone: String, completion : @escaping (_ result : Bool?, _ errorCode: Int? , _ data: NSDictionary? ) -> Void) {

        Alamofire.request(Server_Main_Url + Server_UserLogIn, method: .post, parameters: ["email": email, "phone": self.getPhoneNumber(phone)], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary
            {
                let status = json["status"] as! Int
                
                if status == Success_ServerRequest
                {
                    let dict = json["userInfo"] as! NSDictionary
                    
                    completion(true, status, dict)
                }
                else
                {
                    completion(false, status, nil)
                }
            }
            else
            {
                completion(false, Fail_ServerRequest, nil)
            }
        }
    }
    
    //MARK: Resend Verify Code
    func resendVerifyCode(_ phone: String, completion : @escaping (_ result : Bool, _ data: NSDictionary?) -> Void) {

        Alamofire.request(Server_Main_Url + Server_ResendVerifyCode, method: .post, parameters: ["phone": self.getPhoneNumber(phone)], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary
            {
                let status = json["status"] as! Int
                
            if status == Success_ServerRequest
                {
                    completion(true, json)
                }
                else
                {
                    completion(false, nil)
                }
            }
            else
            {
                completion(false, nil)
            }
        }
    }
    
    //MARK: Get Events
    func allEvents(userID: String, completion: @escaping (_ result: [Event]) -> Void) {
        
        Alamofire.request(Server_GetEvents(userID: userID), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                
                var events = [Event]()
                for obj in json.allValues {
                    let objDict = obj as! [String: AnyObject]
                    let event = Event(dictionary: objDict)
                    events.append(event)
                }
                
                completion(events)
            }
        }
    }
    
    //MARK: Favorites
    
    func favoriteEvents(userID: String, completion: @escaping (_ result: [Event]?) -> Void) {
        
        Alamofire.request(Server_FavoriteEvents(userID: userID), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                
                var events = [Event]()
                for obj in json.allValues {
                    let objDict = obj as! [String: AnyObject]
                    let event = Event(dictionary: objDict)
                    event.isLikedByUser = true
                    events.append(event)
                }
                
                completion(events)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: Like Event
    func likeEvent(userID: String, eventID: String, completion: @escaping (_ result: Bool) -> Void) {
        
        Alamofire.request(Server_LikeEvent(userID: userID, eventID: eventID), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                if let result = json["result"] as? String {
                    if result == "ok" {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    //MARK: Dislike Event
    func dislikeEvent(userID: String, eventID: String, completion: @escaping (_ result: Bool) -> Void) {

        Alamofire.request(Server_DislikeEvent(userID: userID, eventID: eventID), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                if let result = json["result"] as? String{
                    if result == "ok" {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    //MARK: Users liked event
    func usersLikedEvent(eventID: String, completion: @escaping (_ result: [User]?) -> Void) {
        
        Alamofire.request(Server_UsersLikedEvent(eventID: eventID), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                var users = [User]()
                for value in json.allValues {
                    let objDict = value as! [String: AnyObject]
                    let user = User(dictionary: objDict)
                    users.append(user)
                }
                completion(users)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: Update description
    
    func updateDescription(userID: String, description: String, completion: @escaping (_ result: Bool) -> Void) {
        
        Alamofire.request(Server_UpdateDescription(userID: userID, description: description), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    //MARK: Upload file
    
    func uploadFile(fileData: Data, completion: @escaping (_ fileURL: String?) -> Void) {
        
        Alamofire.upload(fileData, to: Server_Upload).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                if let fileURL = json["fileURL"] as? String {
                    completion(fileURL)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func uploadFile(_ image: Data, completionHandler completion: @escaping (_ fileURL: String?) -> Void) {
        let url = Server_Upload
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let image_data = image
        
        if (image_data == nil) {
            return
        }
        
        let body = NSMutableData()
        
        let fname = "photo.png"
        let mimetype = "image/png"
        
        //define the data post parameter
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"photo\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if error != nil {
                print("error: \(error)")
                completion(nil)
                return
            }
            var responseObject: [String: AnyObject]?
            if let data = data {
                do {
                    responseObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
                } catch _ {}
            }
            if let obj = responseObject {
                if let photoURL = obj["photourl"] as? String {
                    completion(photoURL)
                }
            } else {
                completion(nil)
            }
        })
        
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
