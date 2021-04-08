//
//  MapSearchNavigationView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/05.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MapNavigationView: UIView {
  let disposeBag = DisposeBag()
  
  // MARK: - View
  let searchContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  let tipButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavTip"), for: .normal)
  }
  
  let searchField = UITextField().then {
    $0.placeholder = "가게명 또는 카테고리 검색"
  }
  
  let searchButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavSearch"), for: .normal)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
    setupView()
    setupLayout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    searchContainerView.layer.cornerRadius = 16
    searchContainerView.layer.borderWidth = 1
    searchContainerView.layer.borderColor = searchField.isFirstResponder
      ? UIColor.brandPrimary.cgColor
      : UIColor(hexString: "#E5E5EA").cgColor
  }
  
  
}

extension MapNavigationView {
  private func configuration() {
     backgroundColor = .white
  }
  
  private func setupView() {
    
    self.addSubview(searchContainerView)
    searchContainerView.addSubview(tipButton)
    searchContainerView.addSubview(searchField)
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
    
    searchField.snp.makeConstraints {
      $0.leading.equalTo(tipButton.snp.trailing)
      $0.trailing.equalTo(searchButton.snp.leading)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(24)
    }
    
    searchButton.snp.makeConstraints {
      $0.trailing.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }
  }
  
  private func bind() {
    searchField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
      .bind {
        self.setNeedsLayout()
      }.disposed(by: disposeBag)
    
    searchField.rx.controlEvent([.primaryActionTriggered])
      .bind {
        self.searchField.resignFirstResponder()
      }.disposed(by: disposeBag)
    
    searchButton.rx.tap
      .bind {
        self.searchField.resignFirstResponder()
      }.disposed(by: disposeBag)
  }
}
