//
//  SearchResultViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/15.
//

import UIKit

class SearchResultViewController: UIViewController {
  
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLayout()
    setupAttribute()
  }
  
  private func setupLayout() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.bottom.left.right.equalTo(view)
    }
  }
  
  private func setupAttribute() {
    tableView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.rowHeight = SearchResultItemCell.height
      $0.register(SearchResultItemCell.self,
                  forCellReuseIdentifier: SearchResultItemCell.reuseIdentifier)
    }
  }
  
}

extension SearchResultViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultItemCell.reuseIdentifier) as? SearchResultItemCell else {
      return UITableViewCell()
    }
    cell.setSeletedColor()
    
    return cell
  }
}

extension SearchResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // TODO: view -> viewModel
  }
}
