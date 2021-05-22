//
//  PostSearchResultView.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/15.
//

import UIKit
import RxSwift
import RxCocoa

class PostSearchResultView: UIView {
  
  let tableView = UITableView()
  private let emptyView = UIView()
  private let emptyImageView = UIImageView()
  private let emptyLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
    configuration()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.addSubview(tableView)
    emptyView.addSubview(emptyImageView)
    emptyView.addSubview(emptyLabel)
    self.addSubview(emptyView)
    
  }
  
  private func setupLayout() {
    tableView.snp.makeConstraints { make in
      make.top.bottom.left.right.equalTo(self)
    }
    
    
    emptyView.snp.makeConstraints { make in
      make.top.bottom.left.right.equalTo(self)
    }
    
    emptyImageView.snp.makeConstraints {
      $0.width.equalTo(168)
      $0.height.equalTo(195)
      $0.centerX.equalTo(self)
      $0.top.equalTo(self.snp.top).offset(60)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImageView.snp.bottom).offset(26)
      $0.centerX.equalTo(self)
    }
    
  }
  
  private func configuration() {
    tableView.do {
      $0.rowHeight = PostSearchResultItemCell.height
      $0.register(PostSearchResultItemCell.self,
                  forCellReuseIdentifier: PostSearchResultItemCell.reuseIdentifier)
    }
    
    emptyView.do {
      $0.isHidden = true
    }
    
    emptyImageView.do {
      $0.image = #imageLiteral(resourceName: "YongYongEmpty")
    }
    
    emptyLabel.do {
      $0.text = "검색 결과가 없어요"
      $0.font = .krBody2
      $0.textColor = .systemGrayText02
    }
  }
  
  func tableViewIsEmpty(_ isEmpty: Bool) {
    tableView.isHidden = isEmpty
    emptyView.isHidden = !isEmpty
  }
}

