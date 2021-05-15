//
//  RegistrationPasswordViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit

class RegistrationPasswordViewController: ViewController {
  
  let titleLabel = UILabel().then {
    $0.attributedText = NSMutableAttributedString()
      .string("비밀번호를 입력해주세요\n", font: .krTitle1)
      .string("(영문, 숫자 포함 8자 이상)", font: .krBody2)
    $0.numberOfLines = 2
  }
  
  let passwordField = PasswordField()
  let passwordDivider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  let passwordWarningImageView = UIImageView().then {
    $0.image = UIImage(named: "icRegWarning")
    $0.contentMode = .scaleAspectFit
  }
  
  let passwordWarningLabel = UILabel().then {
    $0.text = "올바른 비밀번호 형식이 아닙니다."
    $0.textColor = .brandColorSecondary01
    $0.font = .krCaption2
  }
  
  let passwordConfirmField = PasswordField().then {
    $0.placeHolder = "비밀번호 확인"
  }
  let passwordConfirmDivider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let passwordConfirmWarningImageView = UIImageView().then {
    $0.image = UIImage(named: "icRegWarning")
    $0.contentMode = .scaleAspectFit
  }
  
  let passwordConfirmWarningLabel = UILabel().then {
    $0.text = "비밀번호가 일치하지 않습니다"
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
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? RegistrationPasswordViewModel else { return }
    let input = RegistrationPasswordViewModel.Input(
      next: self.nextButton.rx.tap.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    output.registrationProfile.drive(onNext: { viewModel in
      self.navigator.show(segue: .registrationProfile(viewModel: viewModel), sender: self, transition: .navigation(.right))
    }).disposed(by: disposeBag)
  }
  
  
  override func configuration() {
    super.configuration()
  }
  
  override func setupView() {
    super.setupView()
    [
      titleLabel,
      passwordField, passwordDivider,
      passwordWarningImageView, passwordWarningLabel,
      passwordConfirmField, passwordConfirmDivider,
      passwordConfirmWarningImageView, passwordConfirmWarningLabel,
      nextButton
    ].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(24)
    }
    
    passwordField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(40)
      $0.leading.equalTo(32)
      $0.trailing.equalTo(-31)
      $0.height.equalTo(32)
    }
    
    passwordDivider.snp.makeConstraints {
      $0.top.equalTo(passwordField.snp.bottom)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    
    passwordWarningImageView.snp.makeConstraints {
      $0.top.equalTo(passwordDivider.snp.bottom).offset(6)
      $0.leading.equalTo(24)
      $0.width.height.equalTo(16)
    }
    
    passwordWarningLabel.snp.makeConstraints {
      $0.leading.equalTo(passwordWarningImageView.snp.trailing).offset(8)
      $0.centerY.equalTo(passwordWarningImageView)
    }
    
    passwordConfirmField.snp.makeConstraints {
      $0.top.equalTo(passwordWarningImageView.snp.bottom).offset(2)
      $0.leading.equalTo(32)
      $0.trailing.equalTo(-31)
      $0.height.equalTo(32)
    }
    
    passwordConfirmDivider.snp.makeConstraints {
      $0.top.equalTo(passwordConfirmField.snp.bottom)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    
    passwordConfirmWarningImageView.snp.makeConstraints {
      $0.top.equalTo(passwordConfirmDivider.snp.bottom).offset(6)
      $0.leading.equalTo(24)
      $0.width.height.equalTo(16)
    }
    
    passwordConfirmWarningLabel.snp.makeConstraints {
      $0.leading.equalTo(passwordConfirmWarningImageView.snp.trailing).offset(8)
      $0.centerY.equalTo(passwordConfirmWarningImageView)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-46)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(44)
    }
    
    
  }
}
