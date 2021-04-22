//
//  PostSearchHistoryView.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostSearchHistoryView: UIView {  
  private let containerView = UIView()
  private let titleLabel = UILabel()
  let tableView = UITableView()
  let removeAllButton = UIButton()
  
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
    containerView.addSubview(titleLabel)
    containerView.addSubview(removeAllButton)
    self.addSubview(containerView)
    self.addSubview(tableView)
  }
  
  private func setupLayout() {
    containerView.snp.makeConstraints { make in
      make.width.equalTo(self.snp.width)
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
      make.centerX.equalTo(self)
      make.height.equalTo(38)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(containerView)
      make.left.equalTo(containerView.snp.left).offset(16)
      make.height.equalTo(24)
      make.width.equalTo(140)
    }
    
    removeAllButton.snp.makeConstraints { make in
      make.centerY.equalTo(containerView)
      make.right.equalTo(containerView.snp.right).offset(-16)
      make.height.equalTo(22)
      make.width.equalTo(60)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(containerView.snp.bottom)
      make.left.equalTo(self.snp.left).offset(16)
      make.right.equalTo(self.snp.right).offset(-16)
      make.bottom.equalTo(self.snp.bottom)
    }
    
  }
  
  private func configuration() {
    self.do {
      $0.backgroundColor = .white
    }

    titleLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 14, weight: .regular)
      $0.textColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5725490196, alpha: 1)
      $0.text = "최근 검색어"
    }
    
    removeAllButton.do {
      $0.layer.cornerRadius = 10
      $0.layer.borderWidth = 1
      $0.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1).cgColor
      $0.setTitle("전체삭제", for: .normal)
      $0.setTitleColor(#colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5725490196, alpha: 1), for: .normal) 
      $0.titleLabel?.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
    }
    
    tableView.do {
      $0.separatorStyle = .none
      $0.rowHeight = PostSearchHistoryItemCell.height
      $0.tableFooterView = UIView()
      $0.register(PostSearchHistoryItemCell.self,
                  forCellReuseIdentifier: PostSearchHistoryItemCell.reuseIdentifier)
    }
    
  }

}
