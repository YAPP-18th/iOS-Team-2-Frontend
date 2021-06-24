//
//  MapSearchResultHeaderView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/24.
//

import UIKit

class MapSearchResultHeaderView: UIView {
  let filterButton = UIButton().then {
    $0.setTitle("가까운 순", for: .normal)
    $0.setTitleColor(.systemGrayText02, for: .normal)
    $0.titleLabel?.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.setImage(UIImage(named: "icMapSearchFilter"), for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    
    $0.contentEdgeInsets = .init(top: 7, left: 0, bottom: 7, right: 16)
    $0.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: -8)
  }
  
  let divider = UIView().then {
    $0.backgroundColor = .systemGray05
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
  
  private func configuration() {
    self.backgroundColor = .systemGray00
  }
  
  private func setupView() {
    self.addSubview(filterButton)
    self.addSubview(divider)
  }
  
  private func setupLayout() {
    filterButton.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.centerY.equalToSuperview()
    }
    
    divider.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(1)
    }
  }
}
