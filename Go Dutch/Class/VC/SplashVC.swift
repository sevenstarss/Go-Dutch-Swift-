//
//  SplashVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/2/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class SplashVC: BasicVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = Session.sharedInstance.currentUser
        
        if user == nil
        {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SplashVC.onWelcome), userInfo: nil, repeats: false)
        }
        else
        {
            if user?.verifyStatus == true
            {
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SplashVC.onFeedscreen), userInfo: nil, repeats: false)
            }
            else
            {
                Server().resendVerifyCode((user?.phone)!, completion: { (result, data) in
                    
                    self.hideHud()
                    
                    if result == true
                    {
                        self.onPhoneVerify()
                    }
                })
            }
        }
        
//        self.performSegueWithIdentifier("goTestPref", sender: nil)
    }
    
    func onWelcome() {
        
        self.performSegue(withIdentifier: "goWelcome", sender: nil)
    }
    
    func onFeedscreen() {
        Chat.sharedInstance.connect(user: Session.sharedInstance.currentUser!) { (_) in
            self.performSegue(withIdentifier: "goFeedFromFirstVC", sender: nil)
        }
    }

    func onPhoneVerify() {
        
        self.performSegue(withIdentifier: "goPhoneVerifyFromFirstVC", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
