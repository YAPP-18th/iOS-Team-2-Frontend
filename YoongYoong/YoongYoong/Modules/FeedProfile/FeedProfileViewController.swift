//
//  FeedProfileViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class FeedProfileViewController: ViewController {
  let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = .systemGray04
  }
  
  let nicknameLabel = UILabel().then {
    $0.text = "김용기"
    $0.font = .krTitle1
    $0.textColor = .systemGray01
  }
  
  let badgeButton = UIButton().then {
    $0.setTitle("배지 13개", for: .normal)
    $0.titleLabel?.font = .krBody3
  }
  
  let stateLabel = UILabel().then {
    $0.text = "안녕하세요"
    $0.numberOfLines = 0
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func setupView() {
    super.setupView()
    [profileImageView, nicknameLabel, badgeButton, stateLabel].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(36)
      $0.leading.equalTo(20)
      $0.width.height.equalTo(50)
    }
    
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(nicknameLabel.snp.trailing).offset(14)
    }
    
    badgeButton.snp.makeConstraints {
      $0.trailing.equalTo(-28)
      $0.centerY.equalTo(nicknameLabel)
    }
    
    badgeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    stateLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom)
      $0.leading.equalTo(14)
    }
  }
  
  
}
