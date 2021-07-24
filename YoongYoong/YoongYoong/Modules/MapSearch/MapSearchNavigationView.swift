//
//  MapSearchNavigationView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/19.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MapSearchNavigationView: UIView {
  let disposeBag = DisposeBag()
  
  // MARK: - View
  let searchContainerView = UIView()
  
  let backButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavBack"), for: .normal)
    $0.contentMode = .center
  }
  
  let searchField = UITextField().then {
    $0.borderStyle = .none
    $0.font = .krBody1
    $0.placeholder = "가게명 검색"
    $0.clearButtonMode = .whileEditing
    $0.returnKeyType = .search
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

extension MapSearchNavigationView {
  private func configuration() {
    backgroundColor = isDarkMode ? .systemGray06 : .systemGray00
  }
  
  private func setupView() {
    self.addSubview(backButton)
    self.addSubview(searchContainerView)
    searchContainerView.addSubview(searchField)
    searchContainerView.addSubview(searchButton)
  }
  
  private func setupLayout() {
    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    searchContainerView.snp.makeConstraints {
      $0.leading.equalTo(backButton.snp.trailing).offset(8)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(40)
      $0.centerY.equalToSuperview()
    }
    
    searchButton.snp.makeConstraints {
      $0.trailing.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    searchField.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.trailing.equalTo(searchButton.snp.leading).offset(-6)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(25)
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
