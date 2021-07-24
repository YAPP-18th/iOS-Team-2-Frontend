//
//  MyPageSegmentCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/26.
//

import UIKit

class MyPageSegmentCell: UICollectionViewCell {
  struct ViewModel {
    let image: UIImage?
    let title: String
    let textColor: UIColor
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  
  let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let titleLabel = UILabel().then {
    $0.font = .krCaption1
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    [iconImageView, titleLabel].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    iconImageView.snp.makeConstraints {
      $0.top.equalTo(12)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func updateView() {
    guard let vm = self.viewModel else { return }
    self.iconImageView.image = vm.image
    self.titleLabel.text = vm.title
    self.titleLabel.textColor = vm.textColor
  }
}
