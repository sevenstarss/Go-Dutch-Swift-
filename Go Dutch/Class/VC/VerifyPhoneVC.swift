//
//  VerifyPhoneVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/8/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation

class VerifyPhoneVC: BasicVC {
    
    var str_phoneNo : String!
    var str_verifyCode : String!
    
    @IBOutlet weak var tf_verifyCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onResend(_ sender: AnyObject) {

        self.playSound(Sound_BtnClick)
        self.showHUD("Resending...")

        Server().resendVerifyCode(str_phoneNo) { (result, data) in
            
            self.hideHud()

            if result == true
            {
                print(data)
                
                self.str_verifyCode = String(describing: (data!["verifycode"])!)
                
                self.showAlert("Success", message: "Verification code is sent again to your phone")
            }
            else
            {
                self.showAlert("Error", message: "Can't send Verificatioon code now")
            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if str == str_verifyCode
        {
            self.performSegue(withIdentifier: "goVerifyDone", sender: nil)
            return true
        }
        
        return true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goVerifyDone"
        {
            let vc = segue.destination as! VerifySuccessVC
            
            vc.str_phoneNo = self.str_phoneNo
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
