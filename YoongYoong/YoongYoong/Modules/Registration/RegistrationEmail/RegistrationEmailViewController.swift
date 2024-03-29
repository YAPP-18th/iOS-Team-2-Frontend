//
//  RegistrationEmailViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit
import RxSwift
class RegistrationEmailViewController: ViewController {
  
  let titleLabel = UILabel().then {
    $0.text = "이메일을 입력해주세요"
    $0.font = .krTitle1
    $0.textColor = .systemGrayText01
  }
  
  let emailField = UITextField().then {
    $0.attributedPlaceholder = NSMutableAttributedString().string("이메일", font: .krBody2, color: .systemGray04)
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  let checkImageView = UIImageView().then {
    $0.image = UIImage(named: "icRegFormCheck")
    $0.contentMode = .center
  }
  
  let divider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let warningImageView = UIImageView().then {
    $0.image = UIImage(named: "icRegWarning")
    $0.contentMode = .scaleAspectFit
  }
  
  let warningLabel = UILabel().then {
    $0.text = "이미 등록된 이메일입니다."
    $0.textColor = .brandColorSecondary01
    $0.font = .krCaption2
  }
  
  let nextButton = Button().then {
    $0.setTitle("다음", for: .normal)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? RegistrationEmailViewModel else { return }
    let input = RegistrationEmailViewModel.Input(
      next: self.nextButton.rx.tap.map{[weak self] in
        self?.emailField.text ?? ""
      }.asObservable(),
      emailCheck: emailField.rx.controlEvent(.editingDidEnd)
        .map{[weak self] in
          self?.emailField.text ?? ""
        }.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    output.defaultEmail.drive(self.emailField.rx.text).disposed(by: disposeBag)
    output.registrationPassword.subscribe(onNext: { viewModel in
      self.navigator.show(segue: .registrationPassword(viewModel: viewModel), sender: self, transition: .navigation(.right))
    }).disposed(by: disposeBag)
  
    output.registrationProfile.subscribe(onNext: { viewModel in
      self.navigator.show(segue: .registrationProfile(viewModel: viewModel), sender: self, transition: .navigation(.right))
    }).disposed(by: disposeBag)
    
    Observable.zip(output.validEmail.asObservable(), output.checkEmailResult.asObservable()).subscribe(onNext: { [weak self] in
      let isValid = !(!$0 || !$1)
      self?.warningImageView.isHidden = isValid
      self?.warningLabel.isHidden = isValid
      self?.checkImageView.isHidden = !isValid
      self?.nextButton.isEnabled = isValid
      if !$0 {
        self?.warningLabel.text = "올바른 형식의 이메일이 아닙니다."
      } else if !$1 {
        self?.warningLabel.text = "이미 등록된 이메일입니다."
      }
    }).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .systemGray00
    self.navigationItem.title = "이메일로 가입하기"
    self.setupBackButton()
    nextButton.isEnabled = false
  }
  
  override func setupView() {
    super.setupView()
    [titleLabel, emailField, checkImageView, divider, warningImageView, warningLabel, nextButton].forEach {
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
    
    checkImageView.snp.makeConstraints {
      $0.trailing.equalTo(emailField.snp.trailing)
      $0.centerY.equalTo(emailField)
      $0.width.height.equalTo(24)
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
      $0.top.equalTo(divider.snp.bottom).offset(6)
      $0.leading.equalTo(24)
      $0.width.height.equalTo(16)
    }
    
    warningLabel.snp.makeConstraints {
      $0.leading.equalTo(warningImageView.snp.trailing).offset(8)
      $0.centerY.equalTo(warningImageView)
    }
    
    warningImageView.isHidden = true
    warningLabel.isHidden = true
    checkImageView.isHidden = true
  }
}
