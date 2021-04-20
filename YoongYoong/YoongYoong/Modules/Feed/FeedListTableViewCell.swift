//
//  FeedListTableViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/21.
//

import UIKit
import Then
import SnapKit

class FeedListTableViewCell: UITableViewCell {
  let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let nameLabel = UILabel().then {
    $0.text = "김용기"
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
    $0.textColor = .labelPrimary
    $0.textAlignment = .left
  }
  
  let storeNameLabel = UILabel().then {
    $0.text = "김밥천국 문정점"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .init(hexString: "#828282")
  }
  
  let dateLabel = UILabel().then {
    $0.text = "21.04.24"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .init(hexString: "#828282")
    $0.textAlignment = .right
  }
  
  let contentImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  let containerTitleLabel = UILabel().then {
    $0.text = "용기정보"
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
    $0.textColor = .labelPrimary
  }
  
  let containerListView = FeedListContainerListView()
  
  let divider = UIView().then {
    $0.backgroundColor = .init(hexString: "#E5E5EA")
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    profileImageView.layer.cornerRadius = 19
    profileImageView.layer.masksToBounds = true
    
    containerListView.layer.cornerRadius = 8
    containerListView.layer.borderWidth = 1
    containerListView.layer.borderColor = UIColor(hexString: "#ADADB1").cgColor
  }
}

extension FeedListTableViewCell {
  private func configuration() {
    self.selectionStyle = .none
    self.contentView.backgroundColor = .white
  }
  
  private func setupView() {
    [profileImageView, nameLabel, storeNameLabel, dateLabel, contentImageView, containerTitleLabel, containerListView, divider].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(8)
      $0.leading.equalTo(16)
      $0.width.height.equalTo(38)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(8)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.height.equalTo(18)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(2)
      $0.trailing.equalTo(-15)
      $0.height.equalTo(18)
    }
    
    storeNameLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(2)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.trailing.equalTo(dateLabel.snp.leading).offset(-20)
      $0.height.equalTo(18)
    }
    
    contentImageView.snp.makeConstraints {
      $0.top.equalTo(storeNameLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentImageView.snp.width)
    }
    
    containerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(contentImageView.snp.bottom).offset(16)
      $0.leading.equalTo(16)
    }
    
    containerListView.snp.makeConstraints {
      $0.top.equalTo(containerTitleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
    }
    
    divider.snp.makeConstraints {
      $0.top.equalTo(containerListView.snp.bottom).offset(24)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
    }
  }
  
  private func updateView() {
    
  }
}
