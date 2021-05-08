//
//  TabBarCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/04.
//

import UIKit
import SnapKit

class ContainerListTabBarCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: ContainerListTabBarCell.self)
  
  static func cellSize(availableHeight: CGFloat, title: String?) -> CGSize {
    let cell = ContainerListTabBarCell()
    cell.setTitle(title)
    
    let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
    return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
  }
  
  override var isSelected: Bool {
    didSet {
      title.textColor = isSelected ? .black : .gray
    }
  }
  
  private let title = UILabel().then {
    $0.font = .krBody2
    $0.textAlignment = .center
    $0.textColor = .gray
  }
  
  func setTitle(_ title: String?) { self.title.text = title }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.add(title)
    title.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.top.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().offset(-8)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
