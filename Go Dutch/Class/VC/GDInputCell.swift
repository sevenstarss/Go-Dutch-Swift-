//
//  GDInputCell.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/8/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class GDInputCell: UITableViewCell
{
    @IBOutlet weak var tf_input: FloatLabelTextField!
    @IBOutlet weak var btn_check: UIButton!
    
    var index : InputCellNumber = .input_Name
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        btn_check.round()
        
        tf_input.font = UIFont(name: Font_Dosis_Regular, size: 16)
        tf_input.titleFont = UIFont(name: Font_Dosis_Regular, size: 14)!
        tf_input.titleTextColour =  Color_Gray
        tf_input.titleActiveTextColour = Color_Gray
        tf_input.textColor = Color_Blue
        tf_input.autocorrectionType = .no
        tf_input.spellCheckingType = .no
        
        NotificationCenter.default.addObserver(self, selector: #selector(GDInputCell.onPhoneNoChanged), name: NSNotification.Name(rawValue: Notify_PhoneNumberChanged), object: nil)
    }
    
    func onPhoneNoChanged() {
        
        if index == .input_Phone
        {
            btn_check.isHidden = isValidPhone(tf_input.text) ? false : true
        }
    }
    
//MARK: UITextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if index == .input_Birthday
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Notify_OnClickBirthday), object: nil)
            
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if index == .input_Phone
        {
            return true
        }
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if (str.characters.count > 0)
        {
            if index == .input_Name       //first last name
            {
                btn_check.isHidden = self.isValidFirstLastName(str) ? false : true
            }
            else if index == .input_Email  //Email
            {
                btn_check.isHidden = self.isValidEmail(str) ? false : true
            }
            else
            {
                btn_check.isHidden = false
            }
        }
        else
        {
            btn_check.isHidden = true
        }
        
        return true
    }
}
