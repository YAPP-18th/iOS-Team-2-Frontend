//
//  NSMutableAttributedString+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit

extension NSMutableAttributedString {

  @discardableResult
  func string(_ value: String, font: UIFont, kern: Float = 0) -> NSMutableAttributedString {

    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .kern: kern
    ]

    self.append(NSAttributedString(string: value, attributes: attributes))
    return self
  }

  @discardableResult
  func string(_ value: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {

    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: color
    ]

    self.append(NSAttributedString(string: value, attributes: attributes))
    return self
  }

  @discardableResult
  func string(_ value: String, font: UIFont, kern: Float = 0, color: UIColor) -> NSMutableAttributedString {

    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .kern: kern,
      .foregroundColor: color
    ]

    self.append(NSAttributedString(string: value, attributes: attributes))
    return self
  }

  /* Other styling methods */
  @discardableResult
  func highlight(_ value: String, font: UIFont, highlightColor: UIColor, backgroundColor: UIColor) -> NSMutableAttributedString {

    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: highlightColor,
      .backgroundColor: backgroundColor
    ]

    self.append(NSAttributedString(string: value, attributes: attributes))
    return self
  }

  @discardableResult
  func underlined(_ value: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {

    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: color,
      .underlineStyle: NSUnderlineStyle.single.rawValue
    ]

    self.append(NSAttributedString(string: value, attributes: attributes))
    return self
  }

  @discardableResult
  func highlightTarget(target: String, color: UIColor) -> NSMutableAttributedString? {
    do {
      let regex = try NSRegularExpression(pattern: target.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
      let range = NSRange(location: 0, length: self.string.utf16.count)
      for match in regex.matches(in: self.string.folding(options: .diacriticInsensitive, locale: .current), options: .withTransparentBounds, range: range) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: match.range)
      }
      return self

    } catch {
      return self
    }
  }
}
