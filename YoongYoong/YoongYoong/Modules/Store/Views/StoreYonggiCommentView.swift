//
//  StoreYonggiCommentView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit

class StoreYonggiCommentView: UIView {
  let titleLabel = UILabel().then {
    $0.font = .krTitle1
    $0.text = "포스트"
    $0.textColor = .black
  }
  let yongyongImageView = UIImageView().then {
    $0.image = UIImage(named: "icStoreYongYong")
  }
  
  let commentContainer = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.layer.borderColor = UIColor.brandColorGreen01.cgColor
    $0.layer.borderWidth = 1
  }
  
  let commentLabel = UILabel().then {
    $0.text = "지금까지 총 100개의 용기를 냈어요"
    $0.font = .krBody3
    $0.textColor = .black
  }
  
  // MARK: Object lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    configuration()
    setupView()
    setupLayout()
  }
}

extension StoreYonggiCommentView {
  private func configuration() {
    backgroundColor = UIColor.brandColorTertiary01.withAlphaComponent(0.3)
  }
  
  private func setupView() {
    [titleLabel, yongyongImageView, commentContainer].forEach {
      self.addSubview($0)
    }
    
    commentContainer.addSubview(commentLabel)
  }
  
  private func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.centerY.equalToSuperview()
    }
    
    yongyongImageView.snp.makeConstraints {
      $0.trailing.equalTo(-16)
      $0.width.equalTo(23)
      $0.height.equalTo(35)
      $0.top.equalTo(7.5)
      $0.bottom.equalTo(-7.5)
    }
    
    commentContainer.snp.makeConstraints {
      $0.trailing.equalTo(yongyongImageView.snp.leading).offset(-10)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(20)
    }
    
    commentLabel.snp.makeConstraints {
      $0.leading.equalTo(8)
      $0.trailing.equalTo(-8)
      $0.centerY.equalToSuperview()
    }
  }
  
  private func updateView() {
    
  }
}
