//
//  SignUpVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/8/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation
import UIKit

extension SignUpVC: GMDatePickerDelegate {
    
    func gmDatePicker(_ gmDatePicker: GMDatePicker, didSelect date: Date){
        print(date)
        
        let cell = self.tbl_signup.cellForRow(at: IndexPath(row: 2 , section: 0)) as! GDInputCell
        
        cell.tf_input.text = dateFormatter.string(from: date)
        cell.btn_check.isHidden = false
    }
    
    func gmDatePickerDidCancelSelection(_ gmDatePicker: GMDatePicker) {
        
    }
    
    fileprivate func setupDatePicker() {
        
        datePicker.delegate = self
        
        datePicker.config.startDate = Date()
        
        datePicker.config.animationDuration = 0.5
        
        datePicker.config.cancelButtonTitle = "Cancel"
        datePicker.config.confirmButtonTitle = "Confirm"
        
        datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        datePicker.config.confirmButtonColor = Color_Red
        datePicker.config.cancelButtonColor = Color_Red
    }
}

class SignUpVC: BasicVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_footer: UIView!
    @IBOutlet weak var tbl_signup: TPKeyboardAvoidingTableView!
    @IBOutlet weak var btn_img: UIButton!
    
    var imgData = Data()
    let imagePicker = UIImagePickerController()

    var datePicker = GMDatePicker()
    var dateFormatter = DateFormatter()

    var tf_name : FloatLabelTextField? = nil
    var tf_loc : FloatLabelTextField? = nil
    var tf_birth : FloatLabelTextField? = nil
    var tf_email : FloatLabelTextField? = nil
    var tf_phone : FloatLabelTextField? = nil
    
    var str_verifyCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        self.btn_img.addTarget(self, action: #selector(SignUpVC.onImage), for: .touchUpInside)
        
        tbl_signup.register(UINib(nibName: "GDInputCell", bundle: nil), forCellReuseIdentifier: "gdInputCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.onBirthday), name: NSNotification.Name(rawValue: Notify_OnClickBirthday), object: nil)
        
        dateFormatter.dateFormat = "MMM dd, yyyy"

        setupDatePicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let headerView = tbl_signup.tableHeaderView {
            headerView.height = UIView.factorScreenHeight(174.0)
            tbl_signup.tableHeaderView = headerView
        }
        
        if let footerView = tbl_signup.tableFooterView {
            footerView.height = UIView.factorScreenHeight(200.0)
            tbl_signup.tableFooterView = footerView
        }
        
    }
    
    func onBirthday(){
    
        self.hideKeyboards()
        
        DispatchQueue.main.async {
            
            self.datePicker.show(inVC: self)
        }
        
    }
    
    func hideKeyboards(){
        
        if tf_name != nil
        {
            tf_name?.resignFirstResponder()
        }
        
        if tf_loc != nil
        {
            tf_loc?.resignFirstResponder()
        }
        
        if tf_birth != nil
        {
            tf_birth?.resignFirstResponder()
        }
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return UIView.factorScreenHeight(70)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gdInputCell", for: indexPath) as! GDInputCell
        
        let arr_placeholder = ["Name (first, last)", "Location", "Birthday", "Email (username)", "Phone"]
        
        cell.accessoryType = .none
        cell.backgroundColor = UIColor.clear
        
        cell.index = InputCellNumber(rawValue: (indexPath as NSIndexPath).row)!
        cell.tf_input.placeholder = arr_placeholder[(indexPath as NSIndexPath).row]
        
        cell.tf_input.formatting = (indexPath as NSIndexPath).row == 4 ? .phoneNumber : .noFormatting
        
        cell.tf_input?.keyboardType = .default

        if (indexPath as NSIndexPath).row == 0
        {
            tf_name = cell.tf_input
        }
        else if (indexPath as NSIndexPath).row == 1
        {
            tf_loc = cell.tf_input
        }
        else if (indexPath as NSIndexPath).row == 2
        {
            tf_birth = cell.tf_input
        }
        else if (indexPath as NSIndexPath).row == 3
        {
            tf_email = cell.tf_input
            tf_email?.keyboardType = .emailAddress
        }
        else if (indexPath as NSIndexPath).row == 4
        {
            tf_phone = cell.tf_input
            tf_phone?.keyboardType = .numbersAndPunctuation
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
//MARK: click Image Button
    
    func onImage() {
        
        self.playSound(Sound_BtnClick)
        
        //show the action sheet (i.e. the little pop-up box from the bottom that allows you to choose whether you want to pick a photo from the photo library or from your camera
        let optionMenu = UIAlertController(title: nil, message: "Where would you like the image from?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.modalPresentationStyle = .popover
        
        let photoLibraryOption = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) -> Void in
            
            //shows the photo library
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraOption = UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) -> Void in
            
            //shows the camera
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        //Adding the actions to the action sheet. Camera will only show up as an option if the camera is available in the first place.
        optionMenu.addAction(photoLibraryOption)
        optionMenu.addAction(cancelOption)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true {
            optionMenu.addAction(cameraOption)} else {
        }
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }

// MARK: - Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished picking image")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imgData = UIImageJPEGRepresentation(chosenImage, 0.1)!
        
        self.btn_img.setBackgroundImage(chosenImage, for: UIControlState())
        self.btn_img.layer.borderColor = Color_Red.cgColor
        self.btn_img.layer.borderWidth = 1.0
        self.btn_img.round()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func getCell(_ index : Int) -> GDInputCell {
        
        let cell = self.tbl_signup.cellForRow(at: IndexPath(row: index , section: 0)) as! GDInputCell

        return cell
    }
    
    @IBAction func onJoin(_ sender: AnyObject) {
        
        tbl_signup.scrollToRow(at: IndexPath(row: 0 , section: 0), at: .bottom, animated: true)

        self.playSound(Sound_BtnClick)
        
        self.hideKeyboards()

        let name = tf_name != nil ? tf_name?.text : ""
        let loc = tf_loc != nil ? tf_loc?.text : ""
        let birth = tf_birth != nil ? tf_birth?.text : ""
        let email = tf_email != nil ? tf_email?.text : ""
        let phone = tf_phone != nil ? tf_phone?.text : ""
        
        if name!.characters.count == 0 || loc!.characters.count == 0 || birth!.characters.count == 0 || email!.characters.count == 0 || phone!.characters.count == 0
        {
            self.showAlert("Error", message: "Please Input All Fields")
            return
        }
        
        if !self.view.isValidFirstLastName(name!)
        {
            self.showAlert("Error", message: "Please Input Correct Name")
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

        if imgData.count == 0
        {
            self.showAlert("Error", message: "Please Select Profile Photo")
            return
        }
        
        self.showHUD("Creating...")
        
        Server().uploadFile(self.imgData) { (fileURL) in
            if let url = fileURL {
                Server().registerUser(name!, location: loc!, birthday: birth!, email: email!, phone: phone!, photoURL: url) { (result, erorCode, data) in
                    
                    self.playSound(Sound_SignUpComplete)
                    self.hideHud()
                    
                    if result == true
                    {
                        self.str_verifyCode = String(describing: (data!["verifycode"])!)
                        
                        self.performSegue(withIdentifier: "goPhoneVeiry", sender: nil)
                    }
                    else
                    {
                        if erorCode == ERR_USER_DUPPLICAT_EMAIL || erorCode == ERR_USER_DUPPLICAT_PHONE || erorCode == ERR_USER_DUPPLICAT_EMAIL_PHONE
                        {
                            self.showAlert("Error", message: "Duplicate Email/Phone")
                        }
                        else
                        {
                            self.showAlert("Error", message: "Can't register now")
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goPhoneVeiry"
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
