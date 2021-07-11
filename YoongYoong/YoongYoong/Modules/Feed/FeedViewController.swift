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

class FeedViewController: ViewController {
  var cellHeights = [IndexPath: CGFloat]()

  let tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.backgroundColor = .systemGray06
    $0.separatorStyle = .none
    $0.register(FeedTipView.self, forHeaderFooterViewReuseIdentifier: "FeedTipView")
    $0.register(FeedListTableViewCell.self, forCellReuseIdentifier: "FeedListTableViewCell")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .systemGray06
    self.tableView.dataSource = self
    self.tableView.delegate = self
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
    let input = FeedViewModel.Input(
      feedSelected: self.tableView.rx.itemSelected.asObservable())
    let output = viewModel.transform(input: input)
    
    output.profile.bind(onNext: { [weak self] viewModel in
      self?.navigator.show(segue: .feedProfile(viewModel: viewModel), sender: self, transition: .navigation())
    }).disposed(by: disposeBag)
    
    output.detail.bind(onNext: { [weak self] viewModel in
      self?.navigator.show(segue: .feedDetail(viewModel: viewModel), sender: self, transition: .navigation(.right))
    }).disposed(by: disposeBag)
    
    output.items
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
      self.tableView.reloadDataAndKeepOffset()
      }).disposed(by: disposeBag)
  }
}

extension FeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel = self.viewModel as? FeedViewModel else { return 0 }
    return viewModel.feedElements.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = self.viewModel as? FeedViewModel,
          let cell = tableView.dequeueReusableCell(withIdentifier: FeedListTableViewCell.identifier, for: indexPath) as? FeedListTableViewCell else { return .init() }
    let item = viewModel.feedElements.value[indexPath.row]
    
    cell.viewModel = .init(
      profile: item.user.imageUrl,
      name: item.user.nickname,
      storeName: item.placeName,
      date: item.createdDate,
      imageList: item.images,
      menus: item.postContainers,
      isLiked: item.isLikePressed,
      likeCount: item.likeCount,
      commentCount: item.commentCount
    )
    return cell
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
  
  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 116
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeights[indexPath] ?? UITableView.automaticDimension
  }
}
