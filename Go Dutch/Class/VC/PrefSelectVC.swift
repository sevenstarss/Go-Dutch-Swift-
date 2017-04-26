//
//  PrefSelectVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/3/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

extension PrefSelectVC: GMPickerDelegate {
    
    func gmPicker(_ gmPicker: GMPicker, didSelect string: String) {
        
        if !isPrefSelected
        {
            lbl_iam.text = string
        }
        else
        {
            lbl_pref.text = string
        }
        
    }
    
    func gmPickerDidCancelSelection(_ gmPicker: GMPicker){
        
    }
    
    fileprivate func setupPickerView(){
        
        picker.delegate = self
        picker.config.animationDuration = 0.0
        
        picker.config.cancelButtonTitle = "Cancel"
        picker.config.confirmButtonTitle = "Confirm"
        
        picker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        picker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        picker.config.confirmButtonColor = Color_Red
        picker.config.cancelButtonColor = Color_Red
        
        picker.show(inVC: self)
        picker.dismiss()
        
        picker.config.animationDuration = 0.5
    }
}

class PrefSelectVC: BasicVC, UITextViewDelegate {
    
    @IBOutlet weak var lbl_iam: UILabel!
    @IBOutlet weak var lbl_pref: UILabel!
    @IBOutlet weak var charactersCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var picker = GMPicker()
    var isPrefSelected = false

    let textViewPlaceholderText = "Keep it short and don't overthink it!"
    let placeholderFont = UIFont(name: "SourceSansPro-It", size: 12.0)
    let descriptionFont = UIFont(name: "SourceSansPro-Regular", size: 16.0)
    
    @IBOutlet weak var lastStepTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func showPicker(_ str : String)
    {
        let index = (str != "Select") ? picker.Array.index(of: str) : 0
        picker.gmpicker.selectRow(index!, inComponent: 0, animated: false)
        picker.placementAnswer = (str != "Select") ? str : picker.Array[0]
        
        picker.show(inVC: self)
    }
    
    @IBAction func onContinueButton(_ sender: AnyObject) {
        
        var userDescription = ""
        if self.descriptionTextView.text != self.textViewPlaceholderText {
            userDescription = self.descriptionTextView.text
        }
        
        let server = Server()
        server.updateDescription(userID: Session.sharedInstance.currentUser!.userID, description: userDescription) { (flag) in
            Chat.sharedInstance.connect(user: Session.sharedInstance.currentUser!, completion: { (_) in
                self.performSegue(withIdentifier: "presentTabBar", sender: nil)
            })
        }
    }
    
    @IBAction func onSelectIam(_ sender: AnyObject) {
        
        isPrefSelected = false
        picker.setupGender()

        self.showPicker(lbl_iam.text!)
    }
    
    @IBAction func onSelectPref(_ sender: AnyObject) {
        
        isPrefSelected = true
        picker.setupAllGender()

        self.showPicker(lbl_pref.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == self.textViewPlaceholderText {
            textView.text = ""
            textView.font = self.descriptionFont
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.font = self.placeholderFont
            textView.text = self.textViewPlaceholderText
        } else {
            let user = Session.sharedInstance.currentUser
            user?.userDescription = textView.text
            Session.sharedInstance.currentUser = user
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            if textView.text == self.textViewPlaceholderText {
                self.charactersCountLabel.text = "100"
                return true
            }
        }
        
        let count = textView.text.characters.count - range.length + text.characters.count
        if count <= 100 {
            self.charactersCountLabel.text = "\(100 - count)"
        } else {
            return false
        }
        
        return true
    }
    
    //MARK: - Notification observing
    
    func onKeyboardShow(notification: Notification) {
        
        self.lastStepTopConstraint.constant = -90.0
    }
    
    func onKeyboardHide(notification: Notification) {
        
        self.lastStepTopConstraint.constant = 40.0
    }
    
    
}
