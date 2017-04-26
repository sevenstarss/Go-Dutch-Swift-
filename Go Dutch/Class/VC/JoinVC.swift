//
//  JoinVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/2/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit
import TwitterCore

class JoinVC: BasicVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginTwitterAction(_ sender: AnyObject)
    {
        self.playSound(Sound_BtnClick)
        Twitter.sharedInstance().logIn { session, error in
            
            if (session != nil)
            {
                
                let twitterClient = TWTRAPIClient(userID: session!.userID)
                twitterClient.loadUser(withID: session!.userID, completion: { (twitterUser, error) in
                    let userModel = UserModel()
                    
                    userModel.userid = "10"
                    userModel.email = (session?.userName)! + "@twitter.com"
                    userModel.verifyStatus = true
                    let user = User(userModel: userModel)
                    user.photo = twitterUser?.profileImageLargeURL
                    Session.sharedInstance.currentUser = user
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "goPrefSelect", sender: self)
                    }
                })
            }
            else
            {
                print("error: \(error.debugDescription)");
            }
        }
    }
    
    @IBAction func loginFacebookAction(_ sender: AnyObject) {//action of the custom button in the storyboard
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        self.playSound(Sound_BtnClick)
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if fbloginresult.isCancelled == true
                {
                    return
                }
                
                if fbloginresult.grantedPermissions != nil && (fbloginresult.grantedPermissions.contains("email"))
                {   
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name ,picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                    
                    if let resultDict = result as? NSDictionary {
                        let userModel = UserModel()
                        userModel.userid = "11"
                        userModel.email = resultDict["email"] as? String
                        userModel.name = (resultDict["first_name"] as? String)! + " " + (resultDict["last_name"] as? String)!
                        
                        let picture = resultDict["picture"] as? NSDictionary
                        let data = picture!["data"] as? NSDictionary
                        userModel.photourl = data!["url"] as? String
                        
                        userModel.verifyStatus = true
                        let user = User(userModel: userModel)
                        Session.sharedInstance.currentUser = user
                        
                        self.performSegue(withIdentifier: "goPrefSelect", sender: nil)
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "goPrefSelect"
        {
            self.playSound(Sound_BtnClick)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
