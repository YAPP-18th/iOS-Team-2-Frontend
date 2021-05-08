//
//  ContainerHeaderView.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/04.
//

import UIKit

class ContainerListHeaderView: UITableViewHeaderFooterView {
  static let reuseIdentifier = String(describing: ContainerListHeaderView.self)
  
  let imageView = UIImageView()
  let title = UILabel().then {
    $0.font = .krTitle2
  }

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configurateSectionView()
  }
  
  private func configurateSectionView() {
    contentView.adds([title, imageView])
    contentView.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.9333333333, blue: 0.9607843137, alpha: 1)
    imageView.snp.makeConstraints {
      $0.centerY.equalTo(contentView)
      $0.height.width.equalTo(17)
      $0.left.equalTo(contentView.snp.left).offset(19.5)
    }
    
    title.snp.makeConstraints {
      $0.centerY.equalTo(contentView)
      $0.width.equalTo(308)
      $0.height.equalTo(24)
      $0.left.equalTo(imageView.snp.right).offset(4)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
