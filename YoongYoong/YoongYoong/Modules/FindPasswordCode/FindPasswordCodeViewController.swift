//
//  FindPasswordCodeViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/25.
//

import UIKit

class FindPasswordCodeViewController: ViewController {
  let titleLabel = UILabel().then {
    $0.text = "이메일을 통해 받은 인증코드를 입력해주세요."
    $0.font = .krTitle1
    $0.numberOfLines = 0
    $0.textColor = .systemGrayText01
  }
  
  let codeField = UITextField().then {
    $0.attributedPlaceholder = NSMutableAttributedString().string("인증코드", font: .krBody2, color: .systemGray04)
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  let nextButton = Button().then {
    $0.setTitle("코드 확인", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? FindPasswordCodeViewModel else { return }
    let input = FindPasswordCodeViewModel.Input(
      editingChanged: codeField.rx.controlEvent(.editingDidEnd)
        .map{[weak self] in
          self?.codeField.text ?? ""
        }.asObservable(),
      nextButtonDidTap: self.nextButton.rx.tap.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    output.validCode.drive(self.nextButton.rx.isEnabled).disposed(by: disposeBag)
    output.codeSuccess.bind(onNext: { viewModel in
      self.navigator.show(segue: .findPasswordInput(viewModel: viewModel), sender: self, transition: .navigation(.right))
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
    [titleLabel, codeField, nextButton].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(24)
    }
    
    codeField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(40)
      $0.leading.equalTo(32)
      $0.trailing.equalTo(-31)
      $0.height.equalTo(32)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-46)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(44)
    }
  }
}
