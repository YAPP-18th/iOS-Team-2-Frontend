//
//  AlertTableViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/12.
//

import Foundation
import UIKit

class AlertTableViewCell : UITableViewCell {
  let profileImg = UIImageView().then{
    $0.layer.cornerRadius = 20
    $0.backgroundColor = #colorLiteral(red: 0.7799999714, green: 0.7799999714, blue: 0.8000000119, alpha: 1)
  }
  let alertTitle = UILabel().then {
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = #colorLiteral(red: 0.06700000167, green: 0.06700000167, blue: 0.06700000167, alpha: 1)
  }
  
  private func layout() {
    self.adds([profileImg, alertTitle])
    profileImg.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(18)
      $0.width.height.equalTo(40)
      $0.top.equalTo(15)
    }
    alertTitle.snp.makeConstraints{
      $0.leading.equalTo(profileImg.snp.trailing).offset(6)
      $0.centerY.equalTo(profileImg)
    }
   
  }
  func bind(model : AlertModel) {
    layout()
    self.profileImg.image = UIImage(named: model.profile)
    self.alertTitle.text = model.aletTitle
    self.backgroundColor = model.read ? .white : #colorLiteral(red: 0.9570000172, green: 0.9919999838, blue: 0.9800000191, alpha: 1)
  }
}
