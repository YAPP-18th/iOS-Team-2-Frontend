//
//  MyPostCollectionViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import UIKit
import RxSwift
import RxCocoa

class MyPostView: UIView {
  let disposeBag = DisposeBag()
  
  var postList: [PostResponse] = []
  private let monthlyInformationView = UIView().then{
    $0.backgroundColor = UIColor.brandColorGreen03
  }
  private let timeStampLabel = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .bold)
    $0.textAlignment = .center
    $0.textColor = .black
    $0.text = "2021년 6월"
  }
  private let postImage = UIImageView().then {
    $0.image = UIImage(named: "icMyPostCount")
  }
  private let postCount = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
    $0.textColor = .brandColorTertiary01
    $0.text = "0개"
  }
  private let packageImage = UIImageView().then {
    $0.image = UIImage(named: "icMyPostContainerCount")
  }
  private let packageCount = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
    $0.textColor = .brandColorTertiary01
    $0.text = "0개"
  }
  private let tableView = UITableView().then{
    $0.separatorStyle = .none
    $0.register(StoreReviewCell.self,
                forCellReuseIdentifier: StoreReviewCell.identifier)
  }
  let nextMonthBtn = UIButton().then{
    $0.setImage(UIImage(named: "icMyPostArrowRightActive"), for: .normal)
    $0.contentMode = .center
  }
  let lastMonthBtn = UIButton().then{
    $0.setImage(UIImage(named: "icMyPostArrowLeftActive"), for: .normal)
    $0.contentMode = .center
  }
  private var cellCount = 0
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.tableView.dataSource = self
    self.tableView.delegate = self
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension MyPostView {
  func bindCell(model: PostListModel) {
    cellCount = model.postList.count
    self.timeStampLabel.text = model.month
    self.postCount.text = "\(model.postCount)"
    self.packageCount.text = "\(model.packageCount)"
    self.postList = model.postList
    self.tableView.reloadData()
  }
  
}
extension MyPostView {
  private func setupView() {
    [monthlyInformationView,tableView].forEach {
      self.addSubview($0)
    }
    [timeStampLabel, postImage, postCount, packageImage, packageCount, nextMonthBtn, lastMonthBtn].forEach {
      monthlyInformationView.addSubview($0)
    }
    
  }
  
  private func setupLayout() {
    monthlyInformationView.snp.makeConstraints{
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(78)
    }
    timeStampLabel.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(12)
    }
    nextMonthBtn.snp.makeConstraints{
      $0.centerY.trailing.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    lastMonthBtn.snp.makeConstraints{
      $0.centerY.leading.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    postImage.snp.makeConstraints{
      $0.top.equalTo(timeStampLabel.snp.bottom).offset(11)
      $0.width.height.equalTo(24)
      $0.trailing.equalTo(postCount.snp.leading).offset(-8)
    }
    postCount.snp.makeConstraints{
      $0.centerY.equalTo(postImage)
      $0.trailing.equalTo(monthlyInformationView.snp.centerX).offset(-16)
    }
    packageImage.snp.makeConstraints{
      $0.top.equalTo(timeStampLabel.snp.bottom).offset(11)
      $0.leading.equalTo(monthlyInformationView.snp.centerX).offset(16)
      $0.width.height.equalTo(24)
    }
    packageCount.snp.makeConstraints{
      $0.centerY.equalTo(packageImage)
      $0.leading.equalTo(packageImage.snp.trailing).offset(8)
    }
    tableView.snp.makeConstraints{
      $0.top.equalTo(monthlyInformationView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension MyPostView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.postList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreReviewCell.identifier, for: indexPath) as? StoreReviewCell else { return .init() }
    let item = self.postList[indexPath.row]
    let menu = item.postContainers.map { "\($0.food) \($0.foodCount) "}.joined(separator: "/ ")
    cell.viewModel = .init(name: item.user.nickname, date: item.createdDate, menu: menu, content: item.content ?? "")
    
    let profileToken = ImageDownloadManager.shared.downloadImage(with: item.user.imageUrl) { image in
      cell.profileImageView.image = image
    }
    
    let menuToken = ImageDownloadManager.shared.downloadImage(with: item.images[0]) { image in
      cell.menuImageView.image = image
    }
    
    cell.onReuse = {
      if let profileToken = profileToken,
         let menuToken = menuToken {
        ImageDownloadManager.shared.cancelLoad(profileToken)
        ImageDownloadManager.shared.cancelLoad(menuToken)
      }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
