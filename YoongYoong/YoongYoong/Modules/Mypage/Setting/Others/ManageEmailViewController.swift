//
//  ManageEmailViewController.swift
//  YoongYoong
//
//  Created by denny on 2021/05/15.
//

import Foundation
import RxSwift

class ManageEmailViewController: ViewController {
  let titleLabel = UILabel().then {
    $0.text = "계정 이메일"
    $0.font = .krTitle1
    $0.textColor = .systemGrayText01
  }
  
  let emailLabel = UILabel().then {
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "계정 관리"
  }
  
  override func setupView() {
    [titleLabel, emailLabel].forEach {
      view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
      $0.leading.equalTo(16)
    }
    
    emailLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(21)
      $0.leading.equalTo(titleLabel)
    }
  }
  
  override func bindViewModel() {
    guard let viewModel = self.viewModel as? ManageEmailViewModel else { return }
    let input = ManageEmailViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.email.drive(self.emailLabel.rx.text).disposed(by: disposeBag)
  }
}
