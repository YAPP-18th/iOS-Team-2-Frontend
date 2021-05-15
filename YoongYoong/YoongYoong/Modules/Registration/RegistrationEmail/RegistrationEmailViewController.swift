//
//  RegistrationEmailViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit

class RegistrationEmailViewController: ViewController {
  
  let titleLabel = UILabel().then {
    $0.text = "이메일을 입력해주세요"
    $0.font = .krTitle1
    $0.textColor = .systemGrayText01
  }
  
  let emailField = UITextField().then {
    $0.placeholder = "이메일"
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  let divider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let warningImageView = UIImageView().then {
    $0.image = UIImage(named: "icRegWarning")
    $0.contentMode = .scaleAspectFit
  }
  
  let warningLabel = UILabel().then {
    $0.textColor = .brandColorSecondary01
    $0.font = .krCaption2
  }
  
  let nextButton = UIButton().then {
    $0.backgroundColor = .brandColorGreen02
    $0.setTitle("다음", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 22
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func configuration() {
    super.configuration()
    self.navigationItem.title = "이메일로 가입하기"
  }
  
  override func setupView() {
    super.setupView()
    [titleLabel, emailField, divider, warningImageView, warningLabel, nextButton].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(24)
    }
    
    emailField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(40)
      $0.leading.equalTo(32)
      $0.trailing.equalTo(-31)
      $0.height.equalTo(32)
    }
    
    divider.snp.makeConstraints {
      $0.top.equalTo(emailField.snp.bottom)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-46)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(44)
    }
    
    warningImageView.snp.makeConstraints {
      $0.top.equalTo(6)
      $0.leading.equalTo(24)
      $0.width.height.equalTo(16)
    }
    
    warningLabel.snp.makeConstraints {
      $0.leading.equalTo(warningImageView.snp.trailing).offset(8)
      $0.centerY.equalTo(warningImageView)
    }
  }
}
