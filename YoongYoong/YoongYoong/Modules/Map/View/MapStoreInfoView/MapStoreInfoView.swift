//
//  MapStoreInfoView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/09.
//

import UIKit

class MapStoreInfoView: UIView {
  
  let nameLabel = UILabel().then {
    $0.font = .krTitle2
    $0.text = "점포명"
  }
  
  let distanceLabel = UILabel().then {
    $0.font = .krCaption2
    $0.text = "100m"
    $0.textColor = .systemGrayText02
  }
  
  let postCountLabel = UILabel().then {
    $0.font = .krCaption2
    $0.text = "|   포스트 20개"
    $0.textColor = .systemGrayText02
  }
  
  let locationLabel = UILabel().then {
    $0.font = .krCaption2
    $0.text = "서울 송파구 송파대로 106-17"
  }
  

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.layer.cornerRadius = 16
    self.layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 2, blur: 10, spread: 0)
  }
}

extension MapStoreInfoView {
  private func configuration() {
     backgroundColor = .white
  }
  
  private func setupView() {
    [
      postCountLabel,
      distanceLabel,
      nameLabel,
      locationLabel
    ].forEach {
      self.addSubview($0)
    }

  }
  
  private func setupLayout() {
    self.snp.makeConstraints {
      $0.width.equalTo(322)
      $0.height.equalTo(96)
    }
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.top.equalTo(16)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.leading.equalTo(self.snp.leading).offset(16)
      $0.top.equalTo(nameLabel.snp.bottom).offset(10)
    }
    
    postCountLabel.snp.makeConstraints {
      $0.leading.equalTo(distanceLabel.snp.trailing).offset(4)
      $0.top.equalTo(nameLabel.snp.bottom).offset(10)
    }
    

    [postCountLabel, distanceLabel].forEach {
      $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    locationLabel.snp.makeConstraints {
      $0.leading.equalTo(self.snp.leading).offset(16)
      $0.top.equalTo(distanceLabel.snp.bottom).offset(4)
    }

  }
  
  private func updateView() {
    
  }
}
