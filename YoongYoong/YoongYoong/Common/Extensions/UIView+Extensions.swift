//
//  UIView+Extensions.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/21.
//

import Foundation
import UIKit
extension UIView {
    @discardableResult
    func add<T: UIView>(_ subview: T, then closure: ((T) -> Void)? = nil) -> T {
        addSubview(subview)
        closure?(subview)
        return subview
    }
    
    @discardableResult
    func adds<T: UIView>(_ subviews: [T], then closure: (([T]) -> Void)? = nil) -> [T] {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
        return subviews
    }
  
  func addUnderBar(_ color: UIColor) {
    let underbar = UIView().then{
      $0.backgroundColor = color
    }
    self.add(underbar)
    underbar.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
}

extension UIView {
  var isDarkMode: Bool {
    if #available(iOS 13.0, *) {
      return self.traitCollection.userInterfaceStyle == .dark
    }
    else {
      return false
    }
  }
}
