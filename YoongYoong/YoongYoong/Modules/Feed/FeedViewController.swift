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
  
  let tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.backgroundColor = .systemGray06
    $0.separatorStyle = .none
    $0.register(FeedTipView.self, forHeaderFooterViewReuseIdentifier: "FeedTipView")
    $0.register(FeedListTableViewCell.self, forCellReuseIdentifier: "FeedListTableViewCell")
  }
  
  var cellHeights: [IndexPath: CGFloat] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .systemGray06
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
    
    let dataSource = RxTableViewSectionedReloadDataSource<FeedListSection>(configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListTableViewCell", for: indexPath) as! FeedListTableViewCell
      cell.bind(to: item)
      self.cellHeights[indexPath] = cell.height
      let gesture = UITapGestureRecognizer()
      cell.profileImageView.addGestureRecognizer(gesture)
      
      gesture.rx.event.map { _ in }.bind(to: viewModel.profileSelection).disposed(by: self.disposeBag)
      return cell
    })
    
    output.items.asObservable()
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    
    self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
    output.profile.drive(onNext: { [weak self] viewModel in
      self?.navigator.show(segue: .feedProfile(viewModel: viewModel), sender: self, transition: .navigation())
    }).disposed(by: disposeBag)
  }
}

extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let feedTipView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FeedTipView") as? FeedTipView else { return nil }
    guard let viewModel = self.viewModel as? FeedViewModel else { return nil}
    viewModel.currentDate.bind(to: feedTipView.dateLabel.rx.text).disposed(by: disposeBag)
    viewModel.brave.bind(to: feedTipView.tipLabel.rx.text).disposed(by: disposeBag)
    return feedTipView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 116
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let height = cellHeights[indexPath] else { return .leastNonzeroMagnitude }
    print(height)
    return height
  }
}
