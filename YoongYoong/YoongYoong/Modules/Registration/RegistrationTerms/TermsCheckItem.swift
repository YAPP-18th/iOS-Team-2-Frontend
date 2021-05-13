//
//  TermsCheckItem.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit

class TermsCheckItem: UIView {
  
  let checkButton = UIButton().then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
  }
  
  let checkLabel = UILabel().then {
    $0.font = .krCaption2
    $0.textColor = .systemGrayText01
  }
  
  // MARK: Object lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    configuration()
    setupView()
    setupLayout()
  }
}

extension TermsCheckItem {
  private func configuration() {
    backgroundColor = .white
  }
  
  private func setupView() {
    
  }
  
  private func setupLayout() {
    
  }
  
  private func updateView() {
    
  }
}
