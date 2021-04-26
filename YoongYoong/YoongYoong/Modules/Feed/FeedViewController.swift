//
//  FeedViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class FeedViewController: ViewController {
  let tableView = UITableView().then {
    $0.backgroundColor = .groupTableViewBackground
    $0.register(FeedTipView.self, forHeaderFooterViewReuseIdentifier: "FeedTipView")
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .white
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(tableView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    tableView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel as? FeedViewModel else { return }
    let input = FeedViewModel.Input()
    let output = viewModel.transform(input: input)
    output.sample.drive(tableView.rx.items) { tableView, index, element in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") else { return UITableViewCell() }
      cell.textLabel?.text = element
      return cell
    }.disposed(by: disposeBag)
    self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
  }
}

extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let feedTipView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FeedTipView") as? FeedTipView else { return nil }
    let viewModel = FeedTipViewModel()
    feedTipView.bind(to: viewModel)
    viewModel.date.accept("21.04.24 Sat")
    viewModel.tip.accept("오늘은 냄비로 용기를 내봐용!")
    return feedTipView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 116
  }
}
