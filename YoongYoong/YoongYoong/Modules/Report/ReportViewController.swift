//
//  ReportViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/09/23.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import UIKit

final class ReportViewController: ViewController {
  let containerView = UIView().then {
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
    $0.backgroundColor = .white
  }
  
  let topIndicator = UIView().then {
    $0.backgroundColor = .systemGray06
    $0.layer.cornerRadius = 2.5
  }
  
  let titleLabel = UILabel().then {
    $0.text = "신고 이유는 무엇인가요?"
    $0.font = .krTitle1
    $0.textColor = .systemGrayText01
  }
  
  let checkBox1 = UIButton().then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
    $0.setImage(UIImage(named: "icRecChecked"), for: .highlighted)
    $0.contentMode = .center
  }
  
  let checkLabel1 = UILabel().then {
    $0.text = "용기 관련 게시글이 아니에요."
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  let checkBox2 = UIButton().then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
    $0.setImage(UIImage(named: "icRecChecked"), for: .highlighted)
    $0.contentMode = .center
  }
  
  let checkLabel2 = UILabel().then {
    $0.text = "욕설/비방/혐오 표현이 있어요."
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  let checkBox3 = UIButton().then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
    $0.setImage(UIImage(named: "icRecChecked"), for: .highlighted)
    $0.contentMode = .center
  }
  
  let checkLabel3 = UILabel().then {
    $0.text = "없어진 가게에요."
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  let reportButton = UIButton().then {
    $0.setTitle("신고하기", for: .normal)
    $0.backgroundColor = .brandColorGreen01
    $0.setTitleColor(.white, for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configuration() {
    view.backgroundColor = .black.withAlphaComponent(0.7)
  }
  
  override func setupView() {
    view.addSubview(containerView)
    [
      topIndicator, titleLabel,
      checkBox1, checkLabel1,
      checkBox2, checkLabel2,
      checkBox3, checkLabel3,
      reportButton
    ].forEach { containerView.addSubview($0) }
  }
  
  override func bindViewModel() {
    guard let viewModel = self.viewModel as? ReportViewModel else { return }
    let input = ReportViewModel.Input()
    let output = viewModel.transform(input: input)
  }
  
  override func setupLayout() {
    containerView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    topIndicator.snp.makeConstraints {
      $0.top.equalTo(14)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(CGSize(width: 58, height: 5))
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(topIndicator.snp.bottom).offset(38)
      $0.leading.equalTo(16)
    }
    
    checkBox1.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(18)
      $0.leading.equalTo(16)
      $0.size.equalTo(40)
    }
    
    checkLabel1.snp.makeConstraints {
      $0.centerY.equalTo(checkBox1)
      $0.leading.equalTo(checkBox1.snp.trailing).offset(3)
    }
    
    checkBox2.snp.makeConstraints {
      $0.top.equalTo(checkBox2.snp.bottom)
      $0.leading.equalTo(16)
      $0.size.equalTo(40)
    }
    
    checkLabel2.snp.makeConstraints {
      $0.centerY.equalTo(checkBox1)
      $0.leading.equalTo(checkBox2.snp.trailing).offset(3)
    }
    
    checkBox3.snp.makeConstraints {
      $0.top.equalTo(checkBox2.snp.bottom)
      $0.leading.equalTo(16)
      $0.size.equalTo(40)
    }
    
    checkLabel3.snp.makeConstraints {
      $0.centerY.equalTo(checkBox1)
      $0.leading.equalTo(checkBox3.snp.trailing).offset(3)
    }
    
    reportButton.snp.makeConstraints {
      $0.top.equalTo(checkBox3.snp.bottom).offset(47)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(44)
      $0.bottom.equalTo(-64)
    }
  }
}
