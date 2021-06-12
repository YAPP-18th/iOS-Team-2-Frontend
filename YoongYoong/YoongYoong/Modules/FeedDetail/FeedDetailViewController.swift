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
  let scrollView = ScrollStackView().then {
    $0.contentInset.bottom = 86
  }
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
  
  let contentImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    $0.register(FeedContentCollectionViewCell.self, forCellWithReuseIdentifier: FeedContentCollectionViewCell.identifier)
    $0.isPagingEnabled = true
    $0.backgroundColor = .white
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
  
  let dataSource = RxTableViewSectionedReloadDataSource<FeedDetailMessageSection>(configureCell: { dataSource, tableView, indexPath, item in
    let cell = tableView.dequeueReusableCell(withIdentifier: FeedDetailMessageTableViewCell.identifier, for: indexPath) as! FeedDetailMessageTableViewCell
    cell.bind(to: item)
    return cell
  }, canEditRowAtIndexPath: { _, _ in true })
  
  let collectionDataSource = RxCollectionViewSectionedReloadDataSource<FeedContentImageSection> { _, collectionView, indexPath, viewModel in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedContentCollectionViewCell.identifier, for: indexPath) as? FeedContentCollectionViewCell else { return .init() }
    cell.bind(to: viewModel)
    return cell
  }
  
  let commentInputContainer = UIView().then {
    $0.backgroundColor = .white
  }
  
  let commentInputProfileImageView = UIImageView().then {
    $0.image = UIImage(named: "iconUserAvater")
    $0.contentMode = .scaleAspectFit
  }
  
  let commentFieldContainer = UIView().then{
    $0.layer.cornerRadius = 20
    $0.layer.borderColor = UIColor.systemGray05.cgColor
    $0.layer.borderWidth = 1
  }
  
  let commentField = UITextField().then {
    $0.font = .krBody3
    $0.textColor = .systemGrayText01
    $0.attributedPlaceholder = NSMutableAttributedString(string: "", attributes: [.foregroundColor: UIColor.systemGray04,
                                                                                  .font: UIFont.krBody3])
  }
  
  let sendCommentButton = UIButton().then {
    $0.setImage(UIImage(named: "icFeedDetailBtnSend"), for: .normal)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.commentInputContainer.layer.applySketchShadow(color: .black, alpha: 0.07, x: 0, y: -2, blur: 8, spread: 0)
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? FeedDetailViewModel else { return }
    let input = FeedDetailViewModel.Input(addComment: self.sendCommentButton.rx.tap.map { self.commentField.text ?? "" }.filter { !$0.isEmpty }.asObservable() )
    let output = viewModel.transform(input: input)
    
    
    
    
    
    
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
    contentImageCollectionView.dataSource = nil
    output.images.drive(self.contentImageCollectionView.rx.items(dataSource: collectionDataSource)).disposed(by: disposeBag)
    contentImageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(scrollView)
    self.view.addSubview(commentInputContainer)
    scrollView.addArrangedSubview(contentView)
    
    [authorContainer, contentImageCollectionView, containerTitleLabel, containerListView, divider, likeContainer, messagesContainer, messagesTableView].forEach {
      contentView.addSubview($0)
    }
    
    [profileImageView, nameLabel, moreButton, storeNameLabel, dateLabel].forEach {
      authorContainer.addSubview($0)
    }
    
    likeContainer.addSubview(likeButton)
    messagesContainer.addSubview(messagesButton)
    
    [commentInputProfileImageView, commentFieldContainer].forEach {
      commentInputContainer.addSubview($0)
    }
    
    [commentField, sendCommentButton].forEach {
      commentFieldContainer.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    commentInputContainer.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    commentInputProfileImageView.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
      $0.leading.equalTo(16)
      $0.top.equalTo(8)
      $0.width.height.equalTo(40)
    }
    
    commentFieldContainer.snp.makeConstraints {
      $0.centerY.equalTo(commentInputProfileImageView)
      $0.leading.equalTo(commentInputProfileImageView.snp.trailing).offset(8)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(32)
    }
    
    sendCommentButton.snp.makeConstraints {
      $0.trailing.equalTo(-14)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(20)
    }
    
    commentField.snp.makeConstraints {
      $0.leading.equalTo(8)
      $0.top.equalTo(7)
      $0.bottom.equalTo(-7)
      $0.trailing.equalTo(sendCommentButton.snp.leading).offset(-14)
    }
    
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
    
    contentImageCollectionView.snp.makeConstraints {
      $0.top.equalTo(authorContainer.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentImageCollectionView.snp.width)
    }
    
    containerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(contentImageCollectionView.snp.bottom).offset(16)
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
    
    messagesTableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}
extension FeedDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let item = self.dataSource[indexPath.section].items[indexPath.row]
    let height = FeedDetailMessageTableViewCell.getHeight(viewModel: item)
    return height
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let editAction = UIContextualAction(style: .normal, title: nil) { action, view, completion in
      
      completion(true)
    }
    editAction.image = UIImage(named: "icFeedCommentEdit")
    editAction.backgroundColor = .brandColorTertiary01
    
    let removeAction = UIContextualAction(style: .normal, title: nil) { [weak self]  action, view, completion in
      guard let self = self,
            let viewModel = self.viewModel as? FeedDetailViewModel else { completion(false); return}
      let item = self.dataSource[indexPath.section].items[indexPath.row]
      viewModel.deleteComment.onNext(item.feedMessage)
      completion(true)
    }
    
    removeAction.image = UIImage(named: "icFeedCommentRemove")
    removeAction.backgroundColor = .brandColorSecondary01
    
    return UISwipeActionsConfiguration(actions: [editAction, removeAction])
  }
}
extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.frame.size
  }
}
