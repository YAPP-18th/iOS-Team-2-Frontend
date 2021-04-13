//
//  SearchHistoryViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/12.
//

import UIKit
import SnapKit
import Then

/* TODO:
 1. label 텍스트 크기, 색상 코드화.
*/

class SearchHistoryViewController: UIViewController {
  var dummyData = [["검색어1"], ["검색어2"], ["검색어3"]]

  let tableView = UITableView()
  let containerView = UIView()
  let titleLabel = UILabel()
  let removeAllButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupAttribute()
  }
  
  private func setupLayout() {
    containerView.addSubview(titleLabel)
    containerView.addSubview(removeAllButton)
    view.addSubview(containerView)
    view.addSubview(tableView)
    
    containerView.snp.makeConstraints { make in
      make.width.equalTo(view.snp.width)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
      make.centerX.equalTo(view)
      make.width.equalTo(345)
      make.bottom.equalTo(view.snp.bottom)
    }
    
  }
  
  private func setupAttribute() {
    view.do {
      $0.backgroundColor = .white
    }

    titleLabel.do {
      $0.font = UIFont.sdGhothicNeo(ofSize: 16, weight: .regular)
      $0.textColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5725490196, alpha: 1) // system gray text 02
      $0.text = "최근 검색어"
    }
    
    removeAllButton.do {
      $0.layer.cornerRadius = 10
      $0.layer.borderWidth = 1
      $0.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1).cgColor // system gray 05
      $0.setTitle("전체삭제", for: .normal)
      $0.setTitleColor(#colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5725490196, alpha: 1), for: .normal) // system gray text 02
      $0.titleLabel?.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
      $0.addTarget(self, action: #selector(removeAllButtonDidTap), for: .touchUpInside)
    }
    
    tableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.separatorStyle = .none
      $0.rowHeight = SearchHistoryItemCell.height
      $0.tableFooterView = UIView()
      $0.register(SearchHistoryItemCell.self,
                  forCellReuseIdentifier: SearchHistoryItemCell.reuseIdentifier)
    }
    
  }

  @objc
  private func removeAllButtonDidTap() {
    // TODO: event -> ViewModel
    dummyData.removeAll()
    tableView.reloadData()
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchHistoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return dummyData.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    return view
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryItemCell.reuseIdentifier, for: indexPath) as? SearchHistoryItemCell else {
      return UITableViewCell()
    }
    
    // TODO: ViewModel.output
    cell.textLabel?.text = dummyData[indexPath.section][0]
    
    cell.didDelete = { [weak self] in
      guard let self = self else { return }
      // TODO: event -> viewModel
      self.dummyData.remove(at: indexPath.section)
      tableView.reloadData()
    }
    return cell
  }

}

extension SearchHistoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return SearchHistoryItemCell.cellSpacingHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    // event -> ViewModel
  }
}
