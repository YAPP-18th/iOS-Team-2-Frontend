//
//  FeedTipView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/21.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class FeedTipView: UITableViewHeaderFooterView {
  private let bag = DisposeBag()
  let containerView = UIView()
  let yongyongImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "imgYongYongTip")
  }
  
  let dateLabel = UILabel().then {
    $0.text = "21.04.24 Sat"
    $0.font = .krCaption2
    $0.textColor = .systemGrayText01
  }
  
  let tipLabel = UILabel().then {
    $0.text = "오늘은 냄비로 용기를 내봐용!"
    $0.font = .sdGhothicNeo(ofSize: 16, weight: .bold)
    $0.numberOfLines = 0
  }
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.layer.cornerRadius = 8
    containerView.layer.masksToBounds = true
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = UIColor(red: 209.0 / 255.0, green: 209.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0).cgColor
  }
}

extension FeedTipView {
  private func configuration() {
    contentView.backgroundColor = .systemGray06
    containerView.backgroundColor = .white
  }
  
  private func setupView() {
    contentView.addSubview(containerView)
    [yongyongImageView, dateLabel, tipLabel].forEach {
      containerView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    containerView.snp.makeConstraints {
      $0.top.equalTo(28)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-22)
      $0.bottom.equalTo(-24)
    }
    yongyongImageView.snp.makeConstraints {
      $0.top.equalTo(12)
      $0.leading.equalTo(20)
      $0.width.equalTo(28)
      $0.height.equalTo(42)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(10)
      $0.leading.equalTo(yongyongImageView.snp.trailing).offset(16)
      $0.height.equalTo(16)
    }
    
    tipLabel.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(4)
      $0.leading.equalTo(yongyongImageView.snp.trailing).offset(16)
      $0.trailing.equalTo(-20)
      $0.bottom.equalTo(-14)
      $0.height.greaterThanOrEqualTo(20)
    }
  }
}
