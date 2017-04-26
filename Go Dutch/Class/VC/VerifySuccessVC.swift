//
//  VerifySuccessVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/8/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation

class VerifySuccessVC: BasicVC {
    
    var str_phoneNo : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Server().verifyUser(str_phoneNo, state: "1") { (result, data) in
            
            if data != nil {
                
                let user = User(dictionary: data as! [String : AnyObject])
                user.verifyStatus = true
                

                Session.sharedInstance.currentUser = user
            }

            self.onVerifyDone()
        }
    }
    
    func onVerifyDone() {
        
        Chat.sharedInstance.connect(user: Session.sharedInstance.currentUser!, completion: { (_) in
            self.performSegue(withIdentifier: "goPrefFromVerify", sender: nil)
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
