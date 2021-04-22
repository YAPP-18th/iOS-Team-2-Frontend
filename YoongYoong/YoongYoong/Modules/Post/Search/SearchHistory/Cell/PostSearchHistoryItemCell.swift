//
//  PostSearchHistoryItemCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/12.
//

import UIKit
import SnapKit
import Then

class PostSearchHistoryItemCell: UITableViewCell {
  static let height = CGFloat(32)
  static let reuseIdentifier = String(describing: PostSearchHistoryView.self)
  static let cellSpacingHeight = CGFloat(8)
  
  let deleteButton = UIButton()
  var didDelete: () -> () = {}
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setupAttribute()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    contentView.addSubview(deleteButton)
    deleteButton.snp.makeConstraints { make in
      make.height.equalTo(contentView.snp.height)
      make.width.equalTo(deleteButton.snp.height)
      make.right.equalTo(contentView.snp.right).offset(-10)
      make.centerY.equalTo(contentView)
    }
  }
  
  private func setupAttribute() {
    textLabel?.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
    }
    
    deleteButton.do {
      $0.setImage(#imageLiteral(resourceName: "Close-16px-1"), for: .normal)
      $0.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
  }
  
  @objc
  private func deleteButtonDidTap() {
    didDelete()
  }
}
