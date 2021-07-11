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
  
  func getHeight() -> CGFloat {
    guard let text = self.text,
          !text.isEmpty,
          let font = self.font
    else { return 0 }
    let str = NSString(string: text)
    let width = bounds.size.width
    let height: CGFloat = .greatestFiniteMagnitude
    let size = CGSize(width: width, height: height)
    
    let boundingRect = str.boundingRect(
      with: size,
      options: .usesLineFragmentOrigin,
      attributes: [
        .font: font
      ],
      context: nil
    )
    
    return boundingRect.height
  }
}
