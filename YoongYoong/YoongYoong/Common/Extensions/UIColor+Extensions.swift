//
//  UIColor+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/04.
//

import UIKit

extension UIColor {

  // MARK: Brand

  open class var brandPrimary: UIColor { return UIColor(named: "brandPrimary")! }
  open class var brandSecondary: UIColor { return UIColor(named: "brandSecondary")! }
  open class var brandTertiary: UIColor { return UIColor(named: "brandTertiary")! }
  open class var brandQuarternary: UIColor { return UIColor(named: "brandQuarternary")! }

  // MARK: Label

  open class var labelPrimary: UIColor { return UIColor(named: "labelPrimary")! }
  open class var labelSecondary: UIColor { return UIColor(named: "labelSecondary")! }
  open class var labelTertiary: UIColor { return UIColor(named: "labelTertiary")! }
  open class var labelQuarternary: UIColor { return UIColor(named: "labelQuarternary")! }
  
  // MARK: SystemBackground

  open class var systemBackgroundPrimary: UIColor { return UIColor(named: "systemBackgroundPrimary")! }
  open class var systemBackgroundSecondary: UIColor { return UIColor(named: "systemBackgroundSecondary")! }
  open class var systemBackgroundTertiary: UIColor { return UIColor(named: "systemBackgroundTertiary")! }
}

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

    @nonobjc class var brandColorBlue02: UIColor {
      return UIColor(red: 188.0 / 255.0, green: 233.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var brandColorBlue03: UIColor {
      return UIColor(red: 219.0 / 255.0, green: 238.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }

}
