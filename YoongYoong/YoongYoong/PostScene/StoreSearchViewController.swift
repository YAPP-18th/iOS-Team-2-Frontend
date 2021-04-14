//
//  StoreSearchViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/11.
//

import UIKit
import SnapKit
import Then

class StoreSearchViewController: UIViewController {
  
  let progressView = UIProgressView()
  let titleLabel = UILabel()
  let searchBarContainer = UIView()
  let searchTextField = UITextField()
  let searchButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupLayout()
  }
  
  private func setupLayout() {
    view.addSubview(progressView)
    view.addSubview(titleLabel)
    searchBarContainer.addSubview(searchTextField)
    searchBarContainer.addSubview(searchButton)
    view.addSubview(searchBarContainer)
    
    progressView.snp.makeConstraints { make in
      make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.centerX.equalTo(view)
    }
    
    titleLabel.snp.makeConstraints{ make in
      make.top.equalTo(progressView.snp.bottom).offset(16)
      make.left.equalTo(view.snp.left).offset(16)
    }
    
    searchBarContainer.snp.makeConstraints { make in
      make.width.equalTo(view.snp.width).multipliedBy(0.93)
      make.top.equalTo(titleLabel.snp.bottom).offset(32)
      make.height.equalTo(40)
      make.centerX.equalTo(view)
    }
    
    searchTextField.snp.makeConstraints { make in
      make.centerY.equalTo(searchBarContainer)
      make.height.equalTo(searchBarContainer.snp.height).multipliedBy(0.90)
      make.left.equalTo(searchBarContainer.snp.left).offset(15)
      make.right.equalTo(searchButton.snp.left)
    }
    
    searchButton.snp.makeConstraints { make in
      make.height.equalTo(searchTextField.snp.height)
      make.width.equalTo(searchButton.snp.height)
      make.centerY.equalTo(searchBarContainer)
      make.right.equalTo(searchBarContainer).offset(-5)
    }
    
  }
  
  private func setupAttribute() {
    view.backgroundColor = .white
    progressView.do {
      $0.progressTintColor = .brandPrimary
      $0.progress = 0.5
    }
    
    titleLabel.do {
      $0.text = "어디에서 용기를 냈나요?"
      $0.font = UIFont.sdGhothicNeo(ofSize: 24, weight: .regular)
    }
    
    searchBarContainer.do {
      $0.layer.cornerRadius = 12
      $0.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1).cgColor
      $0.layer.borderWidth = 1
    }
    
    searchTextField.do {
      $0.borderStyle = .none
      $0.placeholder = "검색어를 입력하세요"
      $0.clearButtonMode = .whileEditing
      $0.font = UIFont.sdGhothicNeo(ofSize: 16, weight: .regular)
    }
    
    searchButton.do {
      $0.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    searchButton.do {
      // TODO: 검색 아이콘으로 바꾸기
      $0.setImage(#imageLiteral(resourceName: "searchStroked"), for: .normal)
    }
    
  }
  
  @objc
  private func searchButtonDidTap() {
    // TODO: Search Logic
    print("DidTap")
  }
  
}
