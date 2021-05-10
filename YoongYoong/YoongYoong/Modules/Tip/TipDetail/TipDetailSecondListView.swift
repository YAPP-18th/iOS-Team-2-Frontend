//
//  TipDetailSecondListView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/08.
//

import UIKit

class TipDetailSecondListView: UIView {
  struct VIewModel {
    let icon: UIImage
    var content: String
  }
  
  var viewModel: VIewModel? {
    didSet {
      self.updateView()
    }
  }
  
  
  let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let contentContainer = UIView().then {
    $0.backgroundColor = .brandColorGreen03
    $0.layer.cornerRadius = 16
  }
  
  let contentLabel = UILabel().then {
    $0.textColor = .systemGrayText01
    $0.font = .krBody2
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TipDetailSecondListView {
  private func configuration() {
    
  }
  
  private func setupView() {
    [iconImageView, contentContainer].forEach {
      self.addSubview($0)
    }
    
    contentContainer.addSubview(contentLabel)
  }
  
  private func setupLayout() {
    iconImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.width.equalTo(46)
      $0.height.equalTo(31)
    }
    
    contentContainer.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(9.3)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.bottom.equalToSuperview()
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(18)
      $0.leading.equalTo(6)
      $0.trailing.equalTo(-7)
      $0.bottom.equalTo(-15)
    }
    
  }
  
  private func updateView() {
    guard let viewModel = self.viewModel else { return }
    iconImageView.image = viewModel.icon
    contentLabel.text = viewModel.content
  }
}
