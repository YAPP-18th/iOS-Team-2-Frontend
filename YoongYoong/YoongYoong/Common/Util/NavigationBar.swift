//
//  NavigationBar.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit

class NavigationBar: UIView {
  let barContainer = UIView()
  let leftBarButtonItem = UIButton().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let rightBarButtonItem = UIButton().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let titleLabel = UILabel().then {
    $0.font = .krTitle2
    $0.textColor = .brandColorGreen01
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

extension NavigationBar {
  private func configuration() {
    self.backgroundColor = .systemGray00
  }
  
  private func setupView() {
    self.addSubview(barContainer)
    
    [leftBarButtonItem, titleLabel, rightBarButtonItem].forEach {
      barContainer.addSubview($0)
    }
  }
  
  private func setupLayout() {
    barContainer.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(44)
    }
    
    leftBarButtonItem.snp.makeConstraints {
      $0.width.height.equalTo(24)
      $0.leading.equalTo(8)
      $0.centerY.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    rightBarButtonItem.snp.makeConstraints {
      $0.width.height.equalTo(24)
      $0.trailing.equalTo(-8)
      $0.centerY.equalToSuperview()
    }
  }
}
