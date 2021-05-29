//
//  PostSearchResultItemCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/15.
//

import UIKit

class PostSearchResultItemCell: UITableViewCell {
    
  static let reuseIdentifier = String(describing: PostSearchResultItemCell.self)
  static let height = CGFloat(100)
  
  private let storeLabel = UILabel()
  private let addressLabel = UILabel()
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
    self.addressLabel.text = place.roadAddress.count > 0 ? place.roadAddress : place.address
    self.distanceLabel.text = place.distance.convertDistance()
    self.postLabel.text = "포스트 \(place.reviewCount)개"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    contentView.addSubview(storeLabel)
    contentView.addSubview(distanceLabel)
    contentView.addSubview(verticalBarLabel)
    contentView.addSubview(postLabel)
    contentView.addSubview(addressLabel)

  
    storeLabel.snp.makeConstraints{ make in
      make.leading.equalTo(contentView.snp.leading).offset(16)
      make.top.equalTo(contentView.snp.top).offset(22)
      make.height.equalTo(20)
      make.width.equalTo(208)
    }
    
    distanceLabel.snp.makeConstraints { make in
      make.left.equalTo(contentView.snp.left).offset(16)
      make.top.equalTo(storeLabel.snp.bottom).offset(4)
    }
    
    verticalBarLabel.snp.makeConstraints { make in
      make.height.equalTo(16)
      make.left.equalTo(distanceLabel.snp.right).offset(8)
      make.top.equalTo(storeLabel.snp.bottom).offset(4)
    }
    
    postLabel.snp.makeConstraints { make in
      make.height.equalTo(16)
      make.left.equalTo(verticalBarLabel.snp.right).offset(8)
      make.top.equalTo(storeLabel.snp.bottom).offset(4)
    }
    
    addressLabel.snp.makeConstraints { make in
      make.top.equalTo(distanceLabel.snp.bottom).offset(2)
      make.leading.equalTo(contentView.snp.leading).offset(16)
      make.height.equalTo(16)
      make.width.equalTo(298)
    }
    
   
  }
  
  private func setupAttribute() {
    storeLabel.do {
      $0.font = .krTitle2
      $0.textColor = .systemGrayText01
    }
    
    addressLabel.do {
      $0.font = .krCaption2
      $0.textColor = .systemGrayText01
    }

    distanceLabel.do {
      $0.font = .krCaption2
      $0.textColor = .systemGrayText02
      $0.textAlignment = .left
    }
    
    postLabel.do {
      $0.font = .krCaption2
      $0.textColor = .systemGrayText02
      $0.text = "포스트 20개"
    }
    
    verticalBarLabel.do {
      $0.font = .krCaption2
      $0.textColor = .systemGrayText02
      $0.text = "|"
    }
    
  }
  
  private func setSeletedColor() {
    let backgroundView = UIView()
    backgroundView.backgroundColor = .brandColorGreen04
    self.selectedBackgroundView = backgroundView
  }
  
}
