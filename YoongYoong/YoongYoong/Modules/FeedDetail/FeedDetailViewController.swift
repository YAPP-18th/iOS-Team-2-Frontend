//
//  FeedDetailViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FeedDetailViewController: ViewController {
  let scrollView = ScrollStackView()
  let contentView = UIView()
  
  let authorContainer = UIView()
  
  let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = .lightGray
    $0.isUserInteractionEnabled = true
  }
  
  let nameLabel = UILabel().then {
    $0.text = "김용기"
    $0.font = .krTitle2
    $0.textColor = .systemGrayText01
    $0.textAlignment = .left
  }
  
  let moreButton = UIButton().then {
    $0.setImage(UIImage(named: "icFeedDetailMore"), for: .normal)
  }
  
  let storeNameLabel = UILabel().then {
    $0.text = "김밥천국 문정점"
    $0.font = .krCaption2
    $0.textColor = .init(hexString: "#828282")
  }
  
  let dateLabel = UILabel().then {
    $0.text = "21.04.24"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .init(hexString: "#828282")
    $0.textAlignment = .right
  }
  
  let contentImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .lightGray
  }
  
  let containerTitleLabel = UILabel().then {
    $0.text = "용기정보"
    $0.font = .krTitle2
    $0.textColor = .systemGrayText01
  }
  
  let containerListView = FeedListContainerListView()
  
  let divider = UIView().then {
    $0.backgroundColor = .init(hexString: "#E5E5EA")
  }
  
  let likeContainer = UIView()
  let likeButton = UIButton().then {
    $0.setTitle("123", for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
    $0.titleLabel?.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.setTitleColor(.systemGray02, for: .normal)
    $0.setImage(UIImage(named: "icFeedLikeStroked"), for: .normal)
    $0.centerTextAndImage(spacing: 2)
  }
  
  let messagesContainer = UIView()
  let messagesButton = UIButton().then {
    $0.setTitle("75", for: .normal)
    $0.titleLabel?.font = .krBody3
    $0.imageView?.contentMode = .scaleAspectFit
    $0.setTitleColor(.systemGray02, for: .normal)
    $0.setImage(UIImage(named: "icFeedMessages"), for: .normal)
    $0.centerTextAndImage(spacing: 2)
  }
  
  let messagesTableView = DynamicHeightTableView().then {
    $0.register(FeedDetailMessageTableViewCell.self, forCellReuseIdentifier: FeedDetailMessageTableViewCell.identifier)
  }
  
  var cellHeights: [IndexPath: CGFloat] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? FeedDetailViewModel else { return }
    let input = FeedDetailViewModel.Input()
    let output = viewModel.transform(input: input)
    
    let dataSource = RxTableViewSectionedReloadDataSource<FeedDetailMessageSection>(configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: FeedDetailMessageTableViewCell.identifier, for: indexPath) as! FeedDetailMessageTableViewCell
      cell.bind(to: item)
      self.cellHeights[indexPath] = cell.height
      return cell
    })
    
    output.items.asObservable()
        .bind(to: messagesTableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    output.feed.drive(onNext: { feed in
      ImageDownloadManager.shared.downloadImage(url: feed.user.imageUrl).bind(to: self.profileImageView.rx.image).disposed(by: self.disposeBag)
      self.nameLabel.text = feed.user.nickname
      self.dateLabel.text = feed.createdDate
      self.storeNameLabel.text = feed.placeName
      self.likeButton.setTitle("\(feed.likeCount)", for: .normal)
      self.messagesButton.setTitle("\(feed.commentCount)", for: .normal)
      
      self.containerListView.bind(to: .init(with: feed.postContainers.map { .init(container: $0.container, containerCount: $0.containerCount, food: $0.food, foodCount: $0.foodCount)}))
    }).disposed(by: self.disposeBag)
    messagesTableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(scrollView)
    scrollView.addArrangedSubview(contentView)
    
    [authorContainer, contentImageView, containerTitleLabel, containerListView, divider, likeContainer, messagesContainer, messagesTableView].forEach {
      contentView.addSubview($0)
    }
    
    [profileImageView, nameLabel, moreButton, storeNameLabel, dateLabel].forEach {
      authorContainer.addSubview($0)
    }
    
    likeContainer.addSubview(likeButton)
    messagesContainer.addSubview(messagesButton)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    authorContainer.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(74)
    }
    
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(24)
      $0.leading.equalTo(16)
      $0.width.height.equalTo(38)
    }
    
    moreButton.snp.makeConstraints {
      $0.top.equalTo(8)
      $0.trailing.equalTo(-8)
      $0.width.height.equalTo(24)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(24)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.height.equalTo(18)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(2)
      $0.trailing.equalTo(-15)
    }
    
    dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    storeNameLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(2)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.trailing.equalTo(dateLabel.snp.leading).offset(-20)
      $0.height.equalTo(18)
    }
    
    contentImageView.snp.makeConstraints {
      $0.top.equalTo(authorContainer.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentImageView.snp.width)
    }
    
    containerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(contentImageView.snp.bottom).offset(16)
      $0.leading.equalTo(16)
    }
    
    containerListView.snp.makeConstraints {
      $0.top.equalTo(containerTitleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
    }
    
    divider.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(1)
      $0.bottom.equalTo(likeContainer.snp.top)
    }
    
    likeContainer.snp.makeConstraints {
      $0.top.equalTo(containerListView.snp.bottom).offset(21)
      $0.leading.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(30)
    }
    
    likeButton.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.height.equalTo(16)
    }
    
    messagesContainer.snp.makeConstraints {
      $0.top.equalTo(containerListView.snp.bottom).offset(21)
      $0.trailing.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(30)
    }
    
    messagesButton.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.height.equalTo(16)
    }
    
    messagesTableView.snp.makeConstraints {
      $0.top.equalTo(messagesContainer.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension FeedDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let height = cellHeights[indexPath] else { return .leastNonzeroMagnitude }
    print(height)
    return height
  }
}
