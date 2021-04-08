//
//  MapSearchNavigationView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/05.
//

import UIKit
import Then
import SnapKit

class MapNavigationView: UIView {
  
  // MARK: - View
  let searchContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  let tipButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavTip"), for: .normal)
  }
  
  let searchButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavSearch"), for: .normal)
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    searchContainerView.layer.cornerRadius = 16
    searchContainerView.layer.borderWidth = 1
    searchContainerView.layer.borderColor = UIColor(hexString: "#E5E5EA").cgColor
  }
}

extension MapNavigationView {
  private func configuration() {
     backgroundColor = .white
  }
  
  private func setupView() {
    
    self.addSubview(searchContainerView)
    searchContainerView.addSubview(tipButton)
    searchContainerView.addSubview(searchButton)
  }
  
  private func setupLayout() {
    
    searchContainerView.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(40)
      $0.bottom.equalTo(-9)
    }
    
    tipButton.snp.makeConstraints {
      $0.leading.centerY.equalToSuperview()
      $0.width.height.equalTo(34)
    }
    searchButton.snp.makeConstraints {
      $0.trailing.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }
  }
}
