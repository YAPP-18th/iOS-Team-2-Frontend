//
//  ContainerItemCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/04.
//

import UIKit

class ContainerListItemCell: UITableViewCell {
  
  static let reuseIdentifier = String(describing: ContainerListItemCell.self)
  static let cellHeight = CGFloat(40)
  
  private let titleLabel = UILabel().then {
    $0.font = .krBody3
    $0.text = "냄비"
  }
  private let sizeLabel = UILabel().then {
    $0.font = UIFont.sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8, alpha: 1)
    $0.text = "L"

  }
  lazy var favoriteButton = UIButton().then {
    $0.setImage(UIImage(named: "star.green"), for: .normal)
    $0.setImage(UIImage(named: "star.fill.green"), for: .selected)
    $0.addTarget(self, action: #selector(favoriteButtonDidTap), for: .touchUpInside)
  }
  
  var favoriteDidTap: () -> () = {}
    
  @objc
  private func favoriteButtonDidTap() {
    favoriteDidTap()
  }
  
  private func setupLayout() {
    contentView.adds([titleLabel, sizeLabel, favoriteButton])
    
    titleLabel.snp.makeConstraints {
      $0.left.equalTo(contentView.snp.left).offset(32)
      $0.centerY.equalTo(contentView)
      $0.width.equalTo(200)
      $0.height.equalTo(16)
    }
    
    sizeLabel.snp.makeConstraints {
      $0.left.equalTo(titleLabel.snp.right).offset(8)
      $0.centerY.equalTo(contentView)
      $0.width.equalTo(80)
      $0.height.equalTo(16)
    }
    
    favoriteButton.snp.makeConstraints {
      $0.left.equalTo(sizeLabel.snp.right).offset(8)
      $0.centerY.equalTo(contentView)
      $0.width.equalTo(16)
      $0.height.equalTo(16)
    }

  }
 
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setSeletedColor()
  }
  
  private func setSeletedColor() {
    let backgroundView = UIView()
    backgroundView.backgroundColor = .brandColorGreen04
    self.selectedBackgroundView = backgroundView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
