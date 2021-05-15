//
//  Button.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit

class Button: UIButton {
  override var isEnabled: Bool {
    didSet {
      DispatchQueue.main.async {
        self.updateView()
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.height / 2
  }
}

extension Button {
  private func configuration() {
    self.titleLabel?.font = .krButton1
    self.backgroundColor = .brandColorGreen01
    self.setTitleColor(.white, for: .normal)
  }
  
  private func updateView() {
    self.backgroundColor = isEnabled ? .brandColorGreen01 : .brandColorGreen02
    self.setTitleColor(isEnabled ? .white : .brandColorGreen03, for: .normal)
  }
}
