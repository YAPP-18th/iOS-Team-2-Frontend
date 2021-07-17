//
//  FeedContentImageCollectionViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/29.
//

import UIKit

class FeedContentCollectionViewCell: UICollectionViewCell {
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  var onReuse: () -> Void = { }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
}
extension FeedContentCollectionViewCell {
  private func configuration() {
    
  }
  
  private func setupView() {
    contentView.addSubview(imageView)
  }
  
  private func setupLayout() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
