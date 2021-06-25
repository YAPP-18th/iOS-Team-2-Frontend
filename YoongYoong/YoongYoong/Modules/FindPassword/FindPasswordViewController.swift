//
//  FindPasswordViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/12.
//

import UIKit
import RxSwift

class FindPasswordViewController: ViewController {
  
  let titleLabel = UILabel().then {
    $0.text = "이메일 인증을 통해 비밀번호를\n재설정 하실 수 있습니다."
    $0.font = .krTitle1
    $0.numberOfLines = 0
    $0.textColor = .systemGrayText01
  }
  
  let emailField = UITextField().then {
    $0.attributedPlaceholder = NSMutableAttributedString().string("이메일", font: .krBody2, color: .systemGray04)
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
    $0.text = "올바른 형식의 이메일이 아닙니다."
    $0.textColor = .brandColorSecondary01
    $0.font = .krCaption2
  }
  
  let nextButton = Button().then {
    $0.setTitle("인증 요청", for: .normal)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? FindPasswordViewModel else { return }
    let input = FindPasswordViewModel.Input(
      emailCheck: emailField.rx.controlEvent(.editingDidEnd)
        .map{[weak self] in
          self?.emailField.text ?? ""
        }.asObservable(),
      findPassword: nextButton.rx.tap.map { self.emailField.text ?? "" }.filter { !$0.isEmpty }.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    output.validEmail.asObservable().subscribe(onNext: { [weak self] in
      self?.nextButton.isEnabled = $0
      self?.warningImageView.isHidden = $0
      self?.warningLabel.isHidden = $0
    }).disposed(by: disposeBag)
    
    output.findPasswordCode.subscribe(onNext: { viewModel in
      self.navigator.show(segue: .findPasswordCode(viewModel: viewModel), sender: self, transition: .navigation(.right))
    }).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .systemGray00
    self.navigationItem.title = "비밀번호 찾기"
    self.setupBackButton()
    nextButton.isEnabled = false
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
  }
}

