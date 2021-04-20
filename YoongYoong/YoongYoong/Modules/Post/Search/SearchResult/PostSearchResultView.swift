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
      $0.delegate = self
      $0.dataSource = self
      $0.rowHeight = PostSearchResultItemCell.height
      $0.register(PostSearchResultItemCell.self,
                  forCellReuseIdentifier: PostSearchResultItemCell.reuseIdentifier)
    }
  }
  
}

extension PostSearchResultView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PostSearchResultItemCell.reuseIdentifier) as? PostSearchResultItemCell else {
      return UITableViewCell()
    }
    cell.setSeletedColor()
    
    return cell
  }
}

extension PostSearchResultView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // TODO: view -> viewModel
  }
}
