//
//  TipDetailThirdListView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/08.
//

import UIKit

class TipDetailThirdListView: UIView {
  struct VIewModel {
    let number: UIImage
    let icon: UIImage
    var content: String
  }
  
  var viewModel: VIewModel? {
    didSet {
      self.updateView()
    }
  }
  
  let numberImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let contentLabel = UILabel().then {
    $0.textColor = .systemGrayText01
    $0.font = .krBody2
    $0.numberOfLines = 0
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

extension TipDetailThirdListView {
  private func configuration() {
    
  }
  
  private func setupView() {
    [numberImageView, iconImageView, contentLabel].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupLayout() {
    numberImageView.snp.makeConstraints {
      $0.leading.equalTo(32)
      $0.centerY.equalTo(contentLabel)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(76)
      $0.trailing.equalTo(-7)
    }
    
    iconImageView.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func updateView() {
    guard let viewModel = self.viewModel else { return }
    numberImageView.image = viewModel.number
    iconImageView.image = viewModel.icon
    contentLabel.text = viewModel.content
  }
}

