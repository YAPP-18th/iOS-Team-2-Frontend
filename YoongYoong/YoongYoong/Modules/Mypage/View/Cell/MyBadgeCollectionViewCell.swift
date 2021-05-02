//
//  MyBadgeCollectionViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import UIKit
//import Kingfisher
class MyBadgeCollectionViewCell: UICollectionViewCell {
  private let badgeImage = UIImageView().then{
    $0.backgroundColor = .gray
  }
  private let badgeTitle = UILabel().then{
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .center
  }
}
extension MyBadgeCollectionViewCell {
  private func layout() {
    self.contentView.adds([badgeImage, badgeTitle])
    badgeImage.snp.makeConstraints{
      $0.leading.trailing.top.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width / 3.0 - 20)
      $0.height.equalTo(badgeImage.snp.width)
    }
    badgeTitle.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(badgeImage.snp.bottom).offset(8)
    }
  }
  func bindCell(ImagePath : String, title: String, collected: Bool) {
    layout()
    badgeImage.image = UIImage(named: ImagePath)
    badgeTitle.text = title
    badgeImage.alpha = collected ? 1.0 : 0.5
    badgeTitle.textColor = collected ? .black : .black
  }
}
