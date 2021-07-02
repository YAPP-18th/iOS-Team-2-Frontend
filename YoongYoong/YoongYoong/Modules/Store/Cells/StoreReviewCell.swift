//
//  StoreReviewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/03.
//

import UIKit

class StoreReviewCell: UITableViewCell {
  
  let profileImageView = UIImageView().then {
    $0.image = UIImage(named: "imgDummyProfile")
    $0.contentMode = .scaleAspectFit
  }
  
  let menuImageView = UIImageView().then {
    $0.image = UIImage(named: "imgDummyMenu")
    $0.contentMode = .scaleAspectFit
  }
  
  let nameLabel = UILabel().then {
    $0.text = "김용기"
    $0.textColor = .black
    $0.font = .krTitle3
  }
  
  let dateLabel = UILabel().then {
    $0.text = "21.03.27"
    $0.textColor = .systemGrayText01
    $0.font = .krCaption2
  }
  
  let menuLabel = UILabel().then {
    $0.text = "김밥 2 / 떡볶이 / 오뎅 3"
    $0.textColor = .systemGrayText02
    $0.font = .krCaption2
  }
  
  let contentLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.text = "떡볶이와 김밥, 오뎅을 주문했고 밀폐용기 M사이즈 2개와 L사이즈 1개를 가져갔어요. 오..."
    $0.textColor = .black
    $0.font = .krBody3
  }
  
  
  // MARK: Object lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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

extension StoreReviewCell {
  private func configuration() {
    contentView.backgroundColor = .white
  }
  
  private func setupView() {
    [profileImageView, menuImageView, nameLabel, dateLabel, menuLabel, contentLabel].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(10)
      $0.leading.equalTo(16)
      $0.width.height.equalTo(32)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.height.equalTo(18)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom)
      $0.height.equalTo(18)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
    }
    
    menuImageView.snp.makeConstraints {
      $0.top.equalTo(15)
      $0.bottom.equalTo(-15)
      $0.trailing.equalTo(-16)
      $0.width.height.equalTo(100)
    }
    
    menuLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(13)
      $0.leading.equalTo(16)
      $0.height.equalTo(18)
      $0.trailing.equalTo(menuImageView.snp.leading).offset(-14)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(menuLabel.snp.bottom).offset(2)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(menuImageView.snp.leading).offset(-14)
    }
  }
  
  private func updateView() {
    
  }
}
