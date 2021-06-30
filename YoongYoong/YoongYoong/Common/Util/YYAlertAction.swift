//
//  YYAlertAction.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/01.
//

import UIKit

enum YYAlertActionStyle {
  case cancel
  case `default`
}

typealias YYAlertHandler = (() -> Void)

class YYAlertAction: UIButton {
  
  private lazy var handler: YYAlertHandler? = {
    guard let vc = self.parentViewController as? YYAlertController else { return }
    vc.dismiss(animated: true)
  }
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = .systemGray00
    self.setTitleColor(.brandColorGreen01, for: .normal)
    self.titleLabel?.font = .krButton1
  }
  
  convenience init(title: String?, style: YYAlertActionStyle, handler: YYAlertHandler? = nil) {
    self.init()
    
    switch style {
    case .cancel:
      self.titleLabel?.font = .krButton2
    case .default:
      self.titleLabel?.font = .krButton1
    }
    self.setTitle(title, for: .normal)
    self.handler = handler
    self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  @objc func buttonTapped() {
    guard let vc = self.parentViewController as? YYAlertController else { return }
    vc.dismiss(animated: true) {
      self.handler?()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
