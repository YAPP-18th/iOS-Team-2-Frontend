//
//  UIButton+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/05.
//

import UIKit

extension UIButton {
  func centerTextAndImage(spacing: CGFloat) {
    let insetAmount = spacing / 2
    let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
    let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1
    
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
    self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
  }
}
