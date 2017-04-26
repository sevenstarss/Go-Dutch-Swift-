//  Copyright (c) 2015 Cheering & Chanting AB. All rights reserved.

import Foundation
import UIKit

private var formatterIso: DateFormatter?
private var formatterIsoMilliseconds: DateFormatter?

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension String {
    mutating func replace(_ string:String, replacement:String) {
        let range = self.range(of: " ", options: NSString.CompareOptions.literal, range: nil, locale: nil)
        if let possibleRange = range {
            self.replaceSubrange(possibleRange, with: replacement)
        }
    }
    
    func width(_ fontName: String, fontSize: CGFloat) -> CGFloat {
        let nsString: NSString! = self as NSString!
        if let font = UIFont(name: fontName, size: fontSize) {
            let dictionary = [NSFontAttributeName:font] as NSDictionary
            let size: CGSize = nsString.size(attributes: dictionary as? [String : AnyObject])
            return size.width
        }
        return 0;
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
extension UILabel {
    func setLinespacedText(_ text: String, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
        self.textAlignment = NSTextAlignment.center
    }
}

extension CharacterSet {
    static func usernameCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._")
    }
}

extension UIView {
    func doubleStroke(_ innerStrokeStartColor: UIColor!, innerStrokeEndColor: UIColor!, innerStrokeWidth: CGFloat, outerStrokeColor: UIColor!, outerStrokeWidth: CGFloat) {

        let innerLayer: CALayer = CALayer()
        innerLayer.backgroundColor = UIColor.clear.cgColor
        innerLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        innerLayer.cornerRadius = self.layer.cornerRadius
        innerLayer.borderWidth = innerStrokeWidth
        innerLayer.borderColor = innerStrokeEndColor.cgColor
        self.layer.addSublayer(innerLayer)
        
        let outerLayer: CALayer = CALayer()
        outerLayer.backgroundColor = UIColor.clear.cgColor
        outerLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        outerLayer.cornerRadius = self.layer.cornerRadius
        outerLayer.borderWidth = outerStrokeWidth
        outerLayer.borderColor = outerStrokeColor.cgColor
        self.layer.addSublayer(outerLayer)
        
        /*
        #define kBoarderWidth 3.0
        #define kCornerRadius 8.0
        CALayer *borderLayer = [CALayer layer];
        CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
        [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [borderLayer setFrame:borderFrame];
        [borderLayer setCornerRadius:kCornerRadius];
        [borderLayer setBorderWidth:kBorderWidth];
        [borderLayer setBorderColor:[[UIColor redColor] CGColor]];
        [imageView.layer addSublayer:borderLayer];
        */
    }
    
    //MARK: Validate Email
    
    func isValidEmail(_ YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }

    func isValidPhone(_ value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value) || value.characters.count == 10
        return result
    }
    
    func isValidFirstLastName(_ value: String) -> Bool {
        
        let fullNameArr = value.components(separatedBy: " ")
        
        return fullNameArr.count >= 2 && (fullNameArr[0].characters.count > 0 && fullNameArr[1].characters.count > 0)
    }

    func round() {
        var radius: Float = Float(self.height) / 2.0
        if (self.width >= self.height) {
            radius = Float(self.width) / 2.0
        }
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
    func round(_ radius: Float) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
    func round(_ radius: Float, corners: UIRectCorner) {
        let size = CGSize(width: CGFloat(radius), height: CGFloat(radius))
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = maskPath.cgPath
        self.layer.mask = mask
    }
    
//    func triangulize(direction: TriangleDirection) {
//        let bezierPath = UIBezierPath()
//        if (direction == TriangleDirection.Right) {
//            bezierPath.moveToPoint(CGPoint(x: 0.0, y: 0.0))
//            bezierPath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height))
//            bezierPath.addLineToPoint(CGPoint(x: 0.0, y: self.bounds.height))
//        }
//        if (direction == TriangleDirection.Left) {
//            bezierPath.moveToPoint(CGPoint(x: self.bounds.width, y: 0.0))
//            bezierPath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height))
//            bezierPath.addLineToPoint(CGPoint(x: 0.0, y: self.bounds.height))
//        }
//        bezierPath.closePath()
//        
//        let mask = CAShapeLayer()
//        mask.frame = self.bounds
//        mask.path = bezierPath.CGPath
//        self.layer.mask = mask
//    }
    
    class func factorScreenWidth(_ value: Float) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let factoredValue: Float = ceil((Float(screenWidth) / 414.0) * value) //414.0 is iPhone 6+ screen width
        return CGFloat(factoredValue)
    }
    
    class func factorReal(_ value: Float) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let factoredValue: Float = (Float(screenWidth) / 414.0) * value //414.0 is iPhone 6+ screen width
        return CGFloat(factoredValue)
    }

    class func factorScreenHeight(_ value: Float) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let factoredValue: Float = ceil((Float(screenHeight) / 736.0) * value) //736.0 is iPhone 6+ screen height
        return CGFloat(factoredValue)
    }
    
    class var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    class var screenHeight: CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
}

extension UIViewController {
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

extension UIColor {
    convenience init(hexCode: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexCode.hasPrefix("#") {
            let index   = hexCode.characters.index(hexCode.startIndex, offsetBy: 1)
            let hex     = hexCode.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    red   = CGFloat(1.0)
                    green = CGFloat(1.0)
                    blue  = CGFloat(1.0)
                    alpha = CGFloat(1.0)
                }
            } else {
            }
        } else {
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func customDarkGrayColor() -> UIColor {
        return UIColor(red: 0.153, green: 0.188, blue: 0.196, alpha: 1.0)
    }
    
    class func customLightGrayColor() -> UIColor {
        return UIColor(red: 0.275, green: 0.314, blue: 0.325, alpha: 1.0)
    }
    
    class func customRedColor() -> UIColor {
        return UIColor(red: 0.780, green: 0.286, blue: 0.271, alpha: 1.0)
    }
    
    class func customOrangeColor() -> UIColor {
        return UIColor(red: 0.847, green: 0.239, blue: 0.149, alpha: 1.0)
    }
}


extension UIView {
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(top) {
            self.frame = CGRect(x: self.frame.origin.x, y: top, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    var bottom: CGFloat {
        get {
            return self.frame.size.height + self.frame.origin.y
        }
        set(bottom) {
            self.frame = CGRect(x: self.frame.origin.x, y: bottom - self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    var right: CGFloat {
        get {
            return self.frame.size.width + self.frame.origin.x
        }
        set(right) {
            self.frame = CGRect(x: right - self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(left) {
            self.frame = CGRect(x: left, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(height) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: height)
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(height) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: self.frame.size.height)
        }
    }
}

extension Date {
    static func dateFromIso(_ source: String?) -> Date?
    {
        if(source == nil) { return nil }

        if(formatterIso == nil)
        {
            formatterIso = DateFormatter()
            formatterIso?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        }
        if(formatterIsoMilliseconds == nil)
        {
            formatterIsoMilliseconds = DateFormatter()
            formatterIsoMilliseconds?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S"
        }
        
        formatterIso?.timeZone = TimeZone(abbreviation: "UTC");
        
        if(source?.range(of: ".", options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) == nil)
        {
            return formatterIso?.date(from: source!)
        }
        else
        {
            return formatterIsoMilliseconds?.date(from: source!)
        }
    }
    
    static func timeLeftFrom(_ from: Date, until: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let timeInterval = Int(until.timeIntervalSince(from));

        let days = Int(floor(Double(timeInterval/(60 * 60 * 24))));
        
        var hours = Int(floor(Double(timeInterval/(60 * 60))));
        if (hours > 23) {
            hours = hours - (days * 24);
        }
        
        let minuteDivisor = Double(timeInterval % (60 * 60));
        let minutes = Int(Double(minuteDivisor / 60));
        
        let seconds = Int(ceil(Double(timeInterval % 60)))
        
        return (days, hours, minutes, seconds);
    }
    
    func dayString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_UK")
        return formatter.string(from: self)
    }

    func dateString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.locale = Locale(identifier: "en_UK")
        return formatter.string(from: self)
    }

    func dayTimeString() -> String {
        let formatter: DateFormatter = DateFormatter()
        let now = Date()
        let sevenDaysInSeconds: TimeInterval = Double(7) * 60 * 60 * 24
        let weekFromNow = now.addingTimeInterval(sevenDaysInSeconds)
        if (weekFromNow.compare(self) == ComparisonResult.orderedDescending) {
            formatter.dateFormat = "EEEE h:mm a"
        } else {
            formatter.dateFormat = "EEEE d MMM h:mm a"
        }
        formatter.locale = Locale(identifier: "en_UK")
        return formatter.string(from: self)
    }

    func simpleDayTimeString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "EE h:mm a"
        formatter.locale = Locale(identifier: "en_UK")
        return formatter.string(from: self)
    }

    func timeString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_UK")
        return formatter.string(from: self)
    }
}

//public enum DeviceTypes : String {
//    case simulator      = "Simulator",
//    iPad2          = "iPad 2",
//    iPad3          = "iPad 3",
//    iPhone4        = "iPhone 4",
//    iPhone4S       = "iPhone 4S",
//    iPhone5        = "iPhone 5",
//    iPhone5S       = "iPhone 5S",
//    iPhone5c       = "iPhone 5c",
//    iPad4          = "iPad 4",
//    iPadMini1      = "iPad Mini 1",
//    iPadMini2      = "iPad Mini 2",
//    iPadAir1       = "iPad Air 1",
//    iPadAir2       = "iPad Air 2",
//    iPhone6        = "iPhone 6",
//    iPhone6plus    = "iPhone 6 Plus",
//    unrecognized   = "?unrecognized?"
//}
//
//public extension UIDevice {
//    public var deviceType: DeviceTypes {
//        var sysinfo : [CChar] = Array(count: sizeof(utsname), repeatedValue: 0)
//        let modelCode = sysinfo.withUnsafeMutableBufferPointer {
//            (inout ptr: UnsafeMutableBufferPointer<CChar>) -> DeviceTypes in
//            uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
//            // skip 1st 4 256 byte sysinfo result fields to get "machine" field
//            let machinePtr = ptr.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))
//            var modelMap : [ String : DeviceTypes ] = [
//                "i386"      : .simulator,
//                "x86_64"    : .simulator,
//                "iPad2,1"   : .iPad2,          //
//                "iPad3,1"   : .iPad3,          // (3rd Generation)
//                "iPhone3,1" : .iPhone4,        //
//                "iPhone3,2" : .iPhone4,        //
//                "iPhone4,1" : .iPhone4S,       //
//                "iPhone5,1" : .iPhone5,        // (model A1428, AT&T/Canada)
//                "iPhone5,2" : .iPhone5,        // (model A1429, everything else)
//                "iPad3,4"   : .iPad4,          // (4th Generation)
//                "iPad2,5"   : .iPadMini1,      // (Original)
//                "iPhone5,3" : .iPhone5c,       // (model A1456, A1532 | GSM)
//                "iPhone5,4" : .iPhone5c,       // (model A1507, A1516, A1526 (China), A1529 | Global)
//                "iPhone6,1" : .iPhone5S,       // (model A1433, A1533 | GSM)
//                "iPhone6,2" : .iPhone5S,       // (model A1457, A1518, A1528 (China), A1530 | Global)
//                "iPad4,1"   : .iPadAir1,       // 5th Generation iPad (iPad Air) - Wifi
//                "iPad4,2"   : .iPadAir2,       // 5th Generation iPad (iPad Air) - Cellular
//                "iPad4,4"   : .iPadMini2,      // (2nd Generation iPad Mini - Wifi)
//                "iPad4,5"   : .iPadMini2,      // (2nd Generation iPad Mini - Cellular)
//                "iPhone7,1" : .iPhone6plus,    // All iPhone 6 Plus's
//                "iPhone7,2" : .iPhone6         // All iPhone 6's
//            ]
//            if let model = modelMap[String.fromCString(machinePtr)!] {
//                return model
//            }
//            return DeviceTypes.unrecognized
//        }
//        return modelCode
//    }
//}
