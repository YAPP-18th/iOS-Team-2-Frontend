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
  }
  
  private func setupLayout() {
    tableView.snp.makeConstraints { make in
      make.top.bottom.left.right.equalTo(self)
    }
  }
  
  private func configuration() {
    tableView.do {
      $0.rowHeight = PostSearchResultItemCell.height
      $0.register(PostSearchResultItemCell.self,
                  forCellReuseIdentifier: PostSearchResultItemCell.reuseIdentifier)
    }
  }
}

