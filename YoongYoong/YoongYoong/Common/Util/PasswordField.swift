//
//  PasswordField.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordField: UIView {
  let textField = UITextField().then {
      $0.borderStyle = .none
      $0.attributedPlaceholder = NSMutableAttributedString().string("비밀번호", font: .krBody2, color: .systemGray04)
      $0.font = .krBody2
      $0.textColor = .systemGray01
  }
  let disposeBag = DisposeBag()
  
  var placeHolder = "비밀번호" {
    didSet {
      self.textField.placeholder = placeHolder
    }
  }
  
  lazy var showPasswordButton = UIButton().then {
    $0.setImage(UIImage(named: "icTextFieldHidePassword"), for: .normal)
    $0.contentMode = .scaleAspectFit
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PasswordField {
  private func configuration() {
    self.textField.isSecureTextEntry = true
    
    self.showPasswordButton.rx.tap.subscribe(onNext: {
      self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
      self.updateView()
    }).disposed(by: disposeBag)
  }
  
  private func setupView() {
    addSubview(textField)
    addSubview(showPasswordButton)
  }
  
  private func setupLayout() {
    textField.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.trailing.equalTo(showPasswordButton.snp.leading).offset(-8)
    }
    showPasswordButton.snp.makeConstraints {
      $0.trailing.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
  }
  
  private func updateView() {
    let image = self.textField.isSecureTextEntry ? UIImage(named: "icTextFieldHidePassword") : UIImage(named: "icTextFieldShowPassword")
    self.showPasswordButton.setImage(image, for: .normal)
  }
}
