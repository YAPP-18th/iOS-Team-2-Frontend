//
//  MyPostTableViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import UIKit

class MyPostTableViewCell: UITableViewCell {
  private let thumbNail = UIImageView()
  private let profile = UIImageView().then{
    $0.layer.cornerRadius = 16
    $0.backgroundColor = .lightGray
  }
  private let name = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .bold)
    $0.textColor = .black
  }
  private let postedAt = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .systemGray
  }
  private let menuList = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .systemGray
  }
  private let postContent = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .black
    $0.numberOfLines = 2
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func bind(model: PostSimpleModel) {
    layout()
    self.selectionStyle = .none

    self.thumbNail.image = UIImage(named: model.thumbNail)
    self.profile.image = UIImage(named: model.profile.imagePath ?? "")
    self.name.text = model.profile.name
    self.postedAt.text = model.postedAt
    self.menuList.text = model.menus.map{$0.toStr()}.reduce("") { $0 + "/" + $1 }
    self.postContent.text = model.postDescription
  }
  private func layout() {
    self.contentView.adds([thumbNail,
    profile,
    name,
    postedAt,
    menuList,
    postContent])
    thumbNail.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(100)
      $0.top.equalToSuperview().offset(15)
      $0.trailing.equalToSuperview().offset(-16)
    }
    profile.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(10)
      $0.width.height.equalTo(32)
    }
    name.snp.makeConstraints{
      $0.top.equalTo(profile)
      $0.leading.equalTo(profile.snp.trailing).offset(8)
    }
    postedAt.snp.makeConstraints{
      $0.top.equalTo(name.snp.bottom)
      $0.leading.equalTo(name)
    }
    menuList.snp.makeConstraints{
      $0.top.equalTo(profile.snp.bottom).offset(13)
      $0.leading.equalTo(profile)
      $0.trailing.equalTo(thumbNail.snp.leading).offset(-14)
    }
    postContent.snp.makeConstraints{
      $0.leading.trailing.equalTo(menuList)
      $0.top.equalTo(menuList.snp.bottom).offset(2)
    }
  }
}
