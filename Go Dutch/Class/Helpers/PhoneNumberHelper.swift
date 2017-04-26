//
//  PhoneNumberHelper.swift
//  sndmsg
//
//  Created by Michal Solowow on 3/23/16.
//  Copyright © 2016 Gavin. All rights reserved.
//

import Foundation
import UIKit
import libPhoneNumber_iOS
import CoreTelephony

class PhoneNumberHelper {

    //MARK: Phone Number Management
    
    func getMobileCountryCode() -> String
    {
        let phoneUtil = NBPhoneNumberUtil()
        
        let countryCallingCode = phoneUtil.getCountryCode(forRegion: self.getCountryCode())
        
        return countryCallingCode!.stringValue
    }
    
    func getCountryCode() -> String
    {
        let currentLocale = Locale.current
        let countryCode = (currentLocale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
        
        return countryCode
    }
    
    func formatPhoneNumber(_ pn: String) -> String {
        var resnumber = ""
        let phoneUtil = NBPhoneNumberUtil()
        do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(pn, defaultRegion: self.getCountryCode())
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .RFC3966)
            
            resnumber = formattedString
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return resnumber
    }
    
    //added by Michal check if phone number is valid
    func isValidPhoneNumber(_ pn: String) -> Bool
    {
        do {
            
            let phoneUtil = NBPhoneNumberUtil()
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(pn, defaultRegion: self.getCountryCode())
            
            return phoneUtil.isValidNumber(phoneNumber)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return false
    }

}
