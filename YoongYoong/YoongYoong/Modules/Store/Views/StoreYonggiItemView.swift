//
//  StoreYonggiItemView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit

class StoreYonggiItemView: UIView {
  struct ViewModel {
    let image: UIImage?
    let title: String
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  
  let iconImageView = UIImageView()
  
  let titleLabel = UILabel().then {
    $0.font = .krCaption2
    $0.textColor = .brandColorGreen01
  }
  
  // MARK: Object lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    configuration()
    setupView()
    setupLayout()
  }
}

extension StoreYonggiItemView {
  private func configuration() {
    
  }
  
  private func setupView() {
    [iconImageView, titleLabel].forEach {
      addSubview($0)
    }
  }
  
  private func setupLayout() {
    iconImageView.snp.makeConstraints {
      $0.top.equalTo(14)
      $0.width.height.equalTo(55)
      $0.centerX.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(2)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(-16)
    }
  }
  
  private func updateView() {
    guard let vm = self.viewModel else { return }
    self.iconImageView.image = vm.image
    self.titleLabel.text = vm.title
  }
}
