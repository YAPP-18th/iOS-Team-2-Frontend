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
  let searchContainerView = UIView()
  
  let tipButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavTip"), for: .normal)
  }
  
  let searchField = UITextField().then {
    $0.borderStyle = .none
    $0.font = .krBody1
    $0.placeholder = "가게명 검색"
    $0.textColor = .systemGrayText01
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
      ? UIColor.brandColorGreen01.cgColor
      : UIColor.systemGray05.cgColor
  }
  
  
}

extension MapNavigationView {
  private func configuration() {
    backgroundColor = isDarkMode ? .systemGray06 : .systemGray00
  }
  
  private func setupView() {
    
    self.addSubview(searchContainerView)
    searchContainerView.addSubview(tipButton)
    searchContainerView.addSubview(searchField)
    searchContainerView.addSubview(searchButton)
  }
  
  private func setupLayout() {
    
    searchContainerView.snp.makeConstraints {
      $0.leading.equalTo(8)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(40)
      $0.centerY.equalToSuperview()
    }
    
    tipButton.snp.makeConstraints {
      $0.leading.centerY.equalToSuperview()
      $0.width.height.equalTo(34)
    }
    
    searchButton.snp.makeConstraints {
      $0.trailing.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    searchField.snp.makeConstraints {
      $0.leading.equalTo(tipButton.snp.trailing)
      $0.trailing.equalTo(searchButton.snp.leading)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(24)
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
