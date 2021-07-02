//
//  StoreYonggiView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit

class StoreYonggiView: UIView {
  let viewModelList: [StoreYonggiItemView.ViewModel] = [
    .init(image: UIImage(named: "icContainer001"), title: "밀폐용기 L"),
    .init(image: UIImage(named: "icContainer002"), title: "텀블러 M"),
    .init(image: UIImage(named: "icContainer003"), title: "도시락 M")
  ]
  
  let hStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.backgroundColor = .clear
  }
  
  let containerView = UIView().then {
    $0.backgroundColor = .brandColorGreen03
    $0.layer.cornerRadius = 20
    $0.layer.masksToBounds = true
  }
  
  let titleView = UIView().then {
    $0.backgroundColor = .brandColorGreen02
  }
  
  let titleLabel = UILabel().then {
    $0.textColor = .systemGray00
    $0.font = .krTitle1
    $0.text = "가장 많이 낸 용기"
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

extension StoreYonggiView {
  private func configuration() {
    backgroundColor = .white
  }
  
  private func setupView() {
    self.addSubview(containerView)
    [titleView, hStackView].forEach {
      containerView.addSubview($0)
    }
    titleView.addSubview(titleLabel)
    
    viewModelList.forEach {
      let itemView = StoreYonggiItemView()
      itemView.viewModel = $0
      hStackView.addArrangedSubview(itemView)
    }
  }
  
  private func setupLayout() {
    containerView.snp.makeConstraints {
      $0.top.equalTo(27)
      $0.bottom.equalTo(-32)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
    }
    
    titleView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(34)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    hStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    
  }
  
  private func updateView() {
    
  }
}
