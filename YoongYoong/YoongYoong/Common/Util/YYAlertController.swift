//
//  YYAlertController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/01.
//

import UIKit

class YYAlertController: UIViewController {
  
  private let containerView = UIView().then {
    $0.backgroundColor = .systemGray00
  }
  
  private let titleLabel = UILabel().then {
    $0.textColor = .systemGrayText01
    $0.font = .krTitle1
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = .systemGrayText01
    $0.font = .krBody3
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  private let divider = UIView().then {
    $0.backgroundColor = .init(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.36)
  }
  
  let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.backgroundColor = .init(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.36)
    $0.spacing = 0.5
  }
  
  required init(title: String?, message: String?) {
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
    self.titleLabel.text = title
    self.contentLabel.text = message
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configuration()
    setupView()
    setupLayout()
  }
  
  private func configuration() {
    self.view.backgroundColor = .init(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.7)
  }
  
  private func setupView() {
    view.addSubview(containerView)
    [titleLabel, contentLabel, divider, stackView].forEach {
      containerView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    containerView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.leading.equalTo(52)
      $0.trailing.equalTo(-52)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(2)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
    }
    
    divider.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(contentLabel.snp.bottom).offset(12)
      $0.height.equalTo(0.5)
    }
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(divider.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(44)
    }
  }
  
  func addAction(_ action: YYAlertAction) {
    self.stackView.addArrangedSubview(action)
  }
}
