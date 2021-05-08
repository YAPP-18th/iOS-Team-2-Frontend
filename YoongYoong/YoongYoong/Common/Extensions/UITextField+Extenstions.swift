//
//  UITextField+Extenstions.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
import UIKit

extension UITextField {
  func addUnderBar() {
    let underbar = UIView().then{
      $0.backgroundColor = .black
    }
    self.add(underbar)
    underbar.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
}
