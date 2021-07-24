//
//  UIColor+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/04.
//

import UIKit

public extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIColor{
    @nonobjc class var brandColorTertiary01: UIColor {
        return UIColor(red: 92.0 / 255.0, green: 177.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0)
    }
}
// MARK: - zeplin
extension UIColor {
    @nonobjc class var brandColorGreen01: UIColor {
        return UIColor(named: "brandColorGreen01")!
    }
    
    @nonobjc class var brandColorGreen02: UIColor {
        return UIColor(named: "brandColorGreen02")!
    }
    
    @nonobjc class var brandColorGreen03: UIColor {
        return UIColor(named: "brandColorGreen03")!
    }
    
    @nonobjc class var brandColorGreen04: UIColor {
        return UIColor(named: "brandColorGreen04")!
    }
    
    @nonobjc class var brandColorGreen05: UIColor {
        return UIColor(named: "brandColorGreen05")!
    }
    @nonobjc class var brandColorBlue01: UIColor {
        return UIColor(named: "brandColorTertiary01")!
    }
    @nonobjc class var brandColorBlue02: UIColor {
        return UIColor(named: "brandColorBlue02")!
    }
    
    @nonobjc class var brandColorBlue03: UIColor {
        return UIColor(named: "brandColorBlue03")!
    }
    
    @nonobjc class var brandColorSecondary01: UIColor {
        return UIColor(named: "brandColorSecondary01")!
    }
    
    @nonobjc class var brandColorSecondary02: UIColor {
        return UIColor(named: "brandColorSecondary02")!
    }
    
    @nonobjc class var systemGray00: UIColor {
        return UIColor(named: "systemGray00")!
    }
    
    @nonobjc class var systemGrayText01: UIColor {
        return UIColor(named: "systemGrayText01")!
    }
    
    @nonobjc class var systemGrayText02: UIColor {
        return UIColor(named: "systemGrayText02")!
    }
    
    @nonobjc class var systemGray01: UIColor {
        return UIColor(named: "systemGray01")!
    }
    
    @nonobjc class var systemGray02: UIColor {
        return UIColor(named: "systemGray02")!
    }
    
    @nonobjc class var systemGray03: UIColor {
        return UIColor(named: "systemGray03")!
    }
    
    @nonobjc class var systemGray04: UIColor {
        return UIColor(named: "systemGray04")!
    }
    
    @nonobjc class var systemGray05: UIColor {
        return UIColor(named: "systemGray05")!
    }
    
    @nonobjc class var systemGray06: UIColor {
        return UIColor(named: "systemGray06")!
    }
    
    @nonobjc class var kakaoLoginYellow: UIColor {
        return UIColor(named: "kakaoLoginYellow")!
    }
    
    @nonobjc class var systemGrayText00OnlyLight: UIColor {
        return UIColor(named: "systemGrayText00OnlyLight")!
    }
    
    @nonobjc class var skipLoginButtonBg: UIColor {
        return UIColor(named: "skipLoginButtonBg")!
    }
    
    // MARK: New Color Set
    @nonobjc class var green01: UIColor {
        return UIColor(named: "green01")!
    }
    
    @nonobjc class var green02: UIColor {
        return UIColor(named: "green02")!
    }
    
    @nonobjc class var green03: UIColor {
        return UIColor(named: "green03")!
    }
    
    @nonobjc class var green04: UIColor {
        return UIColor(named: "green04")!
    }
    
    @nonobjc class var blue01: UIColor {
        return UIColor(named: "blue01")!
    }
    
    @nonobjc class var blue02: UIColor {
        return UIColor(named: "blue02")!
    }
    
    @nonobjc class var blue03: UIColor {
        return UIColor(named: "blue03")!
    }
    
    @nonobjc class var red01: UIColor {
        return UIColor(named: "red01")!
    }
    
    @nonobjc class var red02: UIColor {
        return UIColor(named: "red02")!
    }
    
    @nonobjc class var gray01: UIColor {
        return UIColor(named: "gray01")!
    }
    
    @nonobjc class var gray02: UIColor {
        return UIColor(named: "gray02")!
    }
    
    @nonobjc class var gray03: UIColor {
        return UIColor(named: "gray03")!
    }
    
    @nonobjc class var gray04: UIColor {
        return UIColor(named: "gray04")!
    }
    
    @nonobjc class var gray05: UIColor {
        return UIColor(named: "gray05")!
    }
    
    @nonobjc class var gray06: UIColor {
        return UIColor(named: "gray06")!
    }
    
    @nonobjc class var text01: UIColor {
        return UIColor(named: "text01")!
    }
    
    @nonobjc class var text02: UIColor {
        return UIColor(named: "text02")!
    }
    
    @nonobjc class var white000: UIColor {
        return UIColor(named: "white000")!
    }
    
    @nonobjc class var balck000: UIColor {
        return UIColor(named: "black000")!
    }
}
