//
//  PostSearchResultItemCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/15.
//

import UIKit

class PostSearchResultItemCell: UITableViewCell {
    
  static let reuseIdentifier = String(describing: PostSearchResultItemCell.self)
  static let height = CGFloat(128)
  
  private let storeLabel = UILabel()
  private let addressContainer = UIStackView()
  private let hoursContainer = UIStackView()
  private let addressLabel = UILabel()
  private let hoursLabel = UILabel()
  private let addressIcon = UIImageView()
  private let hoursIcon = UIImageView()
  private let distanceLabel = UILabel()
  private let verticalBarLabel = UILabel()
  private let postLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setupAttribute()
    setSeletedColor()
  }
  
  func setupCellData(_ place: Place) {
    self.storeLabel.text = place.name
    self.addressLabel.text = place.address
    self.distanceLabel.text = "\(place.distance)m"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    contentView.addSubview(storeLabel)
    contentView.addSubview(distanceLabel)
    contentView.addSubview(verticalBarLabel)
    contentView.addSubview(postLabel)
    contentView.addSubview(addressContainer)
    addressContainer.addArrangedSubview(addressIcon)
    addressContainer.addArrangedSubview(addressLabel)
    
    contentView.addSubview(hoursContainer)
    hoursContainer.addArrangedSubview(hoursIcon)
    hoursContainer.addArrangedSubview(hoursLabel)
  
    
    storeLabel.snp.makeConstraints{ make in
      make.leading.equalTo(contentView.snp.leading).offset(18)
      make.top.equalTo(contentView.snp.top).offset(17)
      make.height.equalTo(20)
      make.width.equalTo(208)
    }
    
    distanceLabel.snp.makeConstraints { make in
      make.width.equalTo(43)
      make.height.equalTo(16)
      make.left.equalTo(contentView.snp.left).offset(18)
      make.top.equalTo(storeLabel.snp.bottom).offset(3)
    }
    
    verticalBarLabel.snp.makeConstraints { make in
      make.height.equalTo(16)
      make.left.equalTo(distanceLabel.snp.right)
      make.top.equalTo(storeLabel.snp.bottom).offset(3)
    }
    
    postLabel.snp.makeConstraints { make in
      make.height.equalTo(16)
      make.left.equalTo(verticalBarLabel.snp.right).offset(10)
      make.top.equalTo(storeLabel.snp.bottom).offset(3)
    }
    
    addressContainer.snp.makeConstraints { make in
      make.top.equalTo(distanceLabel.snp.bottom).offset(11)
      make.leading.equalTo(contentView.snp.leading).offset(18)
      make.height.equalTo(16)
      make.width.equalTo(298)
    }
    
    addressIcon.snp.makeConstraints { make in
      make.height.equalTo(16)
      make.width.equalTo(16)
    }
    
    hoursContainer.snp.makeConstraints { make in
      make.top.equalTo(addressContainer.snp.bottom).offset(8)
      make.leading.equalTo(contentView.snp.leading).offset(18)
      make.height.equalTo(16)
      make.width.equalTo(298)
    }
    
    hoursIcon.snp.makeConstraints { make in
      make.height.equalTo(16)
      make.width.equalTo(16)
    }

   
  }
  
  private func setupAttribute() {
    storeLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 14, weight: .bold)
      $0.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
      $0.text = "김밥천국"
    }
    
    addressContainer.do {
      $0.spacing = 8
      $0.axis = .horizontal
      $0.distribution = .fill
    }
    
    addressIcon.do {
      $0.image = #imageLiteral(resourceName: "mapsStroked")
    }
    
    addressLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
      $0.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
      $0.text = "서울시 송파구 송파대로 106-17"
    }
    
    hoursContainer.do {
      $0.spacing = 8
      $0.axis = .horizontal
      $0.distribution = .fill
    }
    
    hoursIcon.do {
      $0.image = #imageLiteral(resourceName: "clockStroked")
    }
    
    hoursLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
      $0.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
      $0.text = "매일 00:00 - 24:00"
    }
    
    distanceLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
      $0.textColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5725490196, alpha: 1)
      $0.textAlignment = .left
      $0.text = "600m"

    }
    
    postLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
      $0.textColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5725490196, alpha: 1)
      $0.text = "포스트 20개"
    }
    
    verticalBarLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
      $0.textColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5725490196, alpha: 1)
      $0.text = "|"
    }
    
  }
  
  private func setSeletedColor() {
    let backgroundView = UIView()
    backgroundView.backgroundColor = .brandColorGreen04
    self.selectedBackgroundView = backgroundView
  }
  
}
