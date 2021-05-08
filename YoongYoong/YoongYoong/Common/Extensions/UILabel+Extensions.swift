//
//  UILabel+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import UIKit

extension UILabel {
  func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
    if let text = text {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = font.lineHeight - lineHeight
      
      let attributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: style
      ]
      
      let attrString = NSAttributedString(string: text,
                                          attributes: attributes)
      self.attributedText = attrString
    }
  }
}
