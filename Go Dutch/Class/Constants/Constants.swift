//
//  Constants.swift
//  BLR Connect
//
//  Created by Michael Pieper on 7/23/16.
//  Copyright © 2016 Michal Pieper. All rights reserved.
//

import Foundation
import UIKit

enum InputCellNumber : Int {
    
    case input_Name = 0
    case input_Location = 1
    case input_Birthday = 2
    case input_Email = 3
    case input_Phone = 4
}

//Error Code
let Success_ServerRequest = 200
let Fail_ServerRequest = 201

let ERR_SYSTEM_PARAMTER_NOT_FOUND = 800

let ERR_USER_DUPPLICAT_EMAIL = 1001
let ERR_USER_DUPPLICAT_PHONE = 1002
let ERR_USER_INVALID_VERIFYCODE = 1003
let ERR_USER_REGISTER_FAILED = 1004
let ERR_USER_LOGIN_FAILED = 1005
let ERR_USER_NEED_PHONE_VERIFY = 1006
let ERR_USER_DUPPLICAT_EMAIL_PHONE = 1007
let ERR_USER_NOT_FOUND = 1009
let ERR_USER_INVALID_PHONENUMBER = 1010

//Server Api
let Server_Main_Url : String = "http://23.22.219.141/backend/index.php"

let Server_UserSignUp : String = "/user/signup"
let Server_SetVerify : String = "/user/set_verify"
let Server_UserLogIn : String = "/user/login"
let Server_ResendVerifyCode : String = "/user/resend_verifycode"

let Server_GetEvents: String = "http://23.22.219.141/admin/requests/?action=get_events"
let Server_ImageURL: String = "http://23.22.219.141/admin/events/"
let Server_Upload: String = "http://23.22.219.141/admin/requests/?action=upload_user_file"

func Server_GetEvents(userID: String) -> String {
    return "http://23.22.219.141/admin/requests/?action=get_events&is_liked_by_user_id=\(userID)"
}

func Server_LikeEvent(userID: String, eventID: String) -> String {
    return "http://23.22.219.141/admin/requests/?action=like_event&user_id=\(userID)&event_id=\(eventID)"
}

func Server_FavoriteEvents(userID: String) -> String {
    return "http://23.22.219.141/admin/requests/?action=get_events&liked_by_userid=\(userID)"
}

func Server_DislikeEvent(userID: String, eventID: String) -> String {
    return "http://23.22.219.141/admin/requests/?action=dislike_event&user_id=\(userID)&event_id=\(eventID)"
}

func Server_UsersLikedEvent(eventID: String) -> String {
    return "http://23.22.219.141/admin/requests/?action=get_users_liked_event&event_id=\(eventID)"
}

func Server_UpdateDescription(userID: String, description: String) -> String {
    return "http://23.22.219.141/admin/requests/?action=update_user_description&user_id=\(userID)&user_description=\(description)"
}

//Notification
let Notify_PhoneNumberChanged = "Notify_PhoneNumberChanged"
let Notify_OnClickBirthday = "Notify_OnClickBirthday"
let Notify_HideKeyboards = "Notify_HideKeyboards"

//Colors

let Color_Blue = UIColor(red: 6.0 / 255.0, green: 80.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
let Color_Gray = UIColor(red: 142.0 / 255.0, green: 144.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
let Color_Red = UIColor(red: 221.0 / 255.0, green: 26.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0)

//Font
let Font_Dosis_Regular = "Dosis-Regular"

//Intro Screen
let Number_IntroScreen = 3

//Social Keys
let FaceBook_AppID = "1574103499560921"

let Twitter_ConsumerKey = "waIMVupM48EKPPie0mvzyoe9N"
let Twitter_SecKey = "HxcCjkG0ok67UG1St6XPHeUy2Qcfo0NSfBIEqB7onVT6iYV3Ur"

// Sendbird Messaging

let Sendbird_AppKey = "3EAB49F3-7884-4232-8148-6423696ECE5D"

//Sounds

let Sound_BtnClick = "Click - Tap_Done_Checkbox3"
let Sound_SignUpComplete = "Tiny - Done_PopUp1_1"
