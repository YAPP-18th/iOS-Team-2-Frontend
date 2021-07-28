//
//  MyBadgeCollectionViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import UIKit

class MyBadgeCollectionViewCell: UICollectionViewCell {
  private let badgeImage = UIImageView().then {
    $0.contentMode = .center
  }
  
  private let badgeTitle = UILabel().then {
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .center
  }
}
extension MyBadgeCollectionViewCell {
  private func layout() {
    self.contentView.adds([badgeImage, badgeTitle])
    badgeTitle.snp.makeConstraints {
      $0.bottom.centerX.equalToSuperview()
      $0.height.equalTo(32)
    }
    badgeImage.snp.makeConstraints {
      $0.bottom.equalTo(badgeTitle.snp.top)
      $0.centerX.equalToSuperview()
    }
  }
  func bindCell(ImagePath : String, title: String, collected: Bool) {
    layout()
    badgeImage.image = UIImage(named: ImagePath)
    badgeTitle.text = title
    badgeImage.alpha = collected ? 1.0 : 0.3
    badgeTitle.textColor = collected ? .black : .black
  }
}
