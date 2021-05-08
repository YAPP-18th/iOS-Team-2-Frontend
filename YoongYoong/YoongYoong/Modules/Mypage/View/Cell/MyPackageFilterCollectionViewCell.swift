//
//  MyPackageFilterCollectionViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/06.
//

import UIKit

class MyPackageFilterCollectionViewCell: UICollectionViewCell {
  let label = UILabel().then{
    $0.textAlignment = .center
  }
  override init(frame: CGRect = .zero) {
      super.init(frame: frame)

  }
required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
  private func layout() {
    self.contentView.addSubview(label)
      label.snp.makeConstraints{
        $0.top.bottom.equalToSuperview()
        $0.leading.equalToSuperview().offset(10)
        $0.trailing.equalToSuperview().offset(-10)
        $0.height.equalTo(28)
      }
  }
  func bindCell(_ model : String , selected: Bool) {
      layout()
      label.text = model
    self.label.textColor = selected ? .black : .systemGray
    self.label.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
  }
}
