//
//  MapStoreInfoView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/09.
//

import UIKit

class MapStoreInfoView: UIView {
  
  let nameLabel = UILabel().then {
    $0.text = "점포명"
  }
  
  let distanceLabel = UILabel().then {
    $0.text = "100m"
  }
  
  let postCountLabel = UILabel().then {
    $0.text = "|   포스트 20개"
  }
  
  let locationContainerView = UIView()
  
  let locationIconImageView = UIImageView().then {
    $0.image = UIImage(named: "icMapStoreInfoLocation")
    $0.contentMode = .scaleAspectFit
  }
  
  let locationLabel = UILabel().then {
    $0.text = "서울 송파구 송파대로 106-17"
  }
  
  let timeContainerView = UIView()
  
  let timeIconImageView = UIImageView().then {
    $0.image = UIImage(named: "icMapStoreInfoTime")
    $0.contentMode = .scaleAspectFit
  }
  
  let timeLabel = UILabel().then {
    $0.text = "매일 00:00 - 24:00"
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
      locationContainerView,
      timeContainerView
    ].forEach {
      self.addSubview($0)
    }
    
    [locationIconImageView, locationLabel].forEach {
      locationContainerView.addSubview($0)
    }
    
    [timeIconImageView, timeLabel].forEach {
      timeContainerView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    postCountLabel.snp.makeConstraints {
      $0.top.equalTo(12)
      $0.trailing.equalTo(-16)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.trailing.equalTo(postCountLabel.snp.leading).offset(-10)
      $0.centerY.equalTo(postCountLabel)
    }
    
    [postCountLabel, distanceLabel].forEach {
      $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.centerY.equalTo(distanceLabel)
      $0.trailing.equalTo(distanceLabel.snp.leading)
    }
    
    locationContainerView.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(16)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(24)
    }
    
    locationIconImageView.snp.makeConstraints {
      $0.leading.centerY.equalToSuperview()
      $0.width.height.equalTo(16)
    }
    
    locationLabel.snp.makeConstraints {
      $0.leading.equalTo(locationIconImageView.snp.trailing).offset(4)
      $0.centerY.equalToSuperview()
    }
    
    timeContainerView.snp.makeConstraints {
      $0.top.equalTo(locationContainerView.snp.bottom)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(24)
      $0.bottom.equalTo(-8)
    }
    
    timeIconImageView.snp.makeConstraints {
      $0.leading.centerY.equalToSuperview()
      $0.width.height.equalTo(16)
    }
    
    timeLabel.snp.makeConstraints {
      $0.leading.equalTo(timeIconImageView.snp.trailing).offset(4)
      $0.centerY.equalToSuperview()
    }
  
  }
  
  private func updateView() {
    
  }
}
