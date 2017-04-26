     //
//  LoginVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/8/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation

class LoginVC: BasicVC {

    @IBOutlet weak var tbl_signup: TPKeyboardAvoidingTableView!
    
    var tf_email : FloatLabelTextField? = nil
    var tf_phone : FloatLabelTextField? = nil
    
    var str_verifyCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tbl_signup.register(UINib(nibName: "GDInputCell", bundle: nil), forCellReuseIdentifier: "gdInputCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let headerView = tbl_signup.tableHeaderView {
            headerView.height = UIView.factorScreenHeight(130.0)
            tbl_signup.tableHeaderView = headerView
        }
        
        if let footerView = tbl_signup.tableFooterView {
            footerView.height = UIView.factorScreenHeight(200.0)
            tbl_signup.tableFooterView = footerView
        }
        
    }

    func hideKeyboards(){
        
        if tf_email != nil
        {
            tf_email?.resignFirstResponder()
        }
        
        if tf_phone != nil
        {
            tf_phone?.resignFirstResponder()
        }
        
    }
    
    // MARK: UITableView Delegate
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return UIView.factorScreenHeight(70)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gdInputCell", for: indexPath) as! GDInputCell
        
        let arr_placeholder = ["Email(username)", "Phone"]
        
        cell.accessoryType = .none
        cell.backgroundColor = UIColor.clear
        
        cell.index = InputCellNumber(rawValue: (indexPath as NSIndexPath).row)!
        cell.tf_input.placeholder = arr_placeholder[(indexPath as NSIndexPath).row]
        
        cell.tf_input.formatting = (indexPath as NSIndexPath).row == 1 ? .phoneNumber : .noFormatting
        
        if (indexPath as NSIndexPath).row == 0
        {
            tf_email = cell.tf_input
            tf_email?.keyboardType = .emailAddress
            cell.index = .input_Email
        }
        else if (indexPath as NSIndexPath).row == 1
        {
            tf_phone = cell.tf_input
            tf_phone?.keyboardType = .numbersAndPunctuation
            cell.index = .input_Phone
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func getCell(_ index : Int) -> GDInputCell {
        
        let cell = self.tbl_signup.cellForRow(at: IndexPath(row: index , section: 0)) as! GDInputCell
        
        return cell
    }
    
    @IBAction func onJoin(_ sender: AnyObject) {
        
        self.playSound(Sound_BtnClick)
        tbl_signup.scrollToRow(at: IndexPath(row: 0 , section: 0), at: .bottom, animated: true)
        
        self.hideKeyboards()
        
        let email = tf_email != nil ? tf_email?.text : ""
        let phone = tf_phone != nil ? tf_phone?.text : ""
        
        if email!.characters.count == 0 || phone!.characters.count == 0
        {
            self.showAlert("Error", message: "Please Input All Fields")
            return
        }
        
        if !self.view.isValidEmail(email!)
        {
            self.showAlert("Error", message: "Please Input Correct Email")
            return
        }
        
        if !self.view.isValidPhone(phone!)
        {
            self.showAlert("Error", message: "Please Input Correct Phone No")
            return
        }
        
        self.showHUD("Logging in...")
        
        Server().signinUser(email!, phone: phone!) { (result, errorCode, data) in
            
            print(data)
            
            if result == true
            {
                let userInfo = UserModel(dict: data!)
                userInfo.verifyStatus = true
                let user = User(userModel: userInfo)
                Session.sharedInstance.currentUser = user

                Chat.sharedInstance.connect(user: user, completion: { (_) in
                    
                    self.hideHud()

                    self.performSegue(withIdentifier: "goFeedFromLogin", sender: nil)
                })
            }
            else
            {
                if errorCode == ERR_USER_NEED_PHONE_VERIFY
                {
                    Server().resendVerifyCode(phone!, completion: { (result, data) in
                        
                        self.hideHud()
                        
                        if result == true
                        {
                            print(data)
                            
                            let userInfo = UserModel(dict: data!)
                            userInfo.verifyStatus = false
                            UserDefaultsService.saveUser(userInfo)

                            self.str_verifyCode = String(describing: (data!["verifycode"])!)

                            self.performSegue(withIdentifier: "goPrefFromLogin", sender: nil)
                            return
                        }
                    })
                }
                else
                {
                    self.hideHud()

                    self.showAlert("Error", message: "Invalid Email/Phone number")
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goPrefFromLogin"
        {
            let vc = segue.destination as! VerifyPhoneVC
            
            vc.str_phoneNo = tf_phone?.text
            vc.str_verifyCode = self.str_verifyCode
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
