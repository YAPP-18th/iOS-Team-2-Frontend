//
//  FeedListTableViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/21.
//

import UIKit
import Then
import SnapKit

class FeedListTableViewCell: UITableViewCell {

  struct ViewModel {
    let profile: String?
    let name: String?
    let storeName: String?
    let date: String?
    let imageList: [String]
    let menus: [PostContainerModel]
    let isLiked: Bool
    let likeCount: Int
    let commentCount: Int
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  
  var onReuse: () -> Void = { }
  var onLike: () -> Void = { }
  var onProfile: () -> Void = { }
  let profileButton = UIButton().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = .lightGray
  }
  
  let nameLabel = UILabel().then {
    $0.text = "김용기"
    $0.font = .krTitle2
    $0.textColor = .systemGrayText01
    $0.textAlignment = .left
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
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      layout.sectionInset = .zero
      
      let width = UIScreen.main.bounds.size.width
      layout.itemSize = .init(width: width, height: width)
    }
    $0.register(FeedContentCollectionViewCell.self, forCellWithReuseIdentifier: FeedContentCollectionViewCell.identifier)
    $0.backgroundColor = .systemGray00
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
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
    $0.contentEdgeInsets = .init(top: 3, left: 6, bottom: 3, right: 8)
    $0.titleEdgeInsets = .init(top: 0, left: 2, bottom: 0, right: -2)
  }
  
  let messagesContainer = UIView()
  let messagesButton = UIButton().then {
    $0.setTitle("75", for: .normal)
    $0.titleLabel?.font = .krBody3
    $0.imageView?.contentMode = .scaleAspectFit
    $0.setTitleColor(.systemGray02, for: .normal)
    $0.setImage(UIImage(named: "icFeedMessagesStroked"), for: .normal)
    $0.contentEdgeInsets = .init(top: 3, left: 6, bottom: 3, right: 8)
    $0.titleEdgeInsets = .init(top: 0, left: 2, bottom: 0, right: -2)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    profileButton.layer.cornerRadius = 19
    profileButton.layer.masksToBounds = true
    
    containerListView.layer.cornerRadius = 8
    containerListView.layer.borderWidth = 1
    containerListView.layer.borderColor = UIColor(hexString: "#ADADB1").cgColor
  }
  
  @objc func likeButtonTapped() {
    self.onLike()
  }
  @objc func profileButtonTapped() {
    self.onProfile()
  }
}

extension FeedListTableViewCell {
  private func configuration() {
    self.selectionStyle = .none
    self.contentView.backgroundColor = .systemGray00
    self.contentImageCollectionView.dataSource = self
    
    likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
  }
  
  private func setupView() {
    [
      profileButton, nameLabel, storeNameLabel, dateLabel,
      contentImageCollectionView,
      containerTitleLabel, containerListView,
      divider,
      likeContainer, messagesContainer
    ].forEach {
      self.contentView.addSubview($0)
    }
    
    likeContainer.addSubview(likeButton)
    messagesContainer.addSubview(messagesButton)
  }
  
  private func setupLayout() {
    profileButton.snp.makeConstraints {
      $0.top.equalTo(25)
      $0.leading.equalTo(16)
      $0.width.height.equalTo(38)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileButton.snp.trailing).offset(8)
      $0.top.equalTo(profileButton.snp.top)
    }
    
    dateLabel.snp.makeConstraints {
      $0.bottom.equalTo(profileButton.snp.bottom)
      $0.trailing.equalTo(-15)
    }
    
    dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    storeNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(profileButton.snp.bottom)
      $0.leading.equalTo(profileButton.snp.trailing).offset(8)
      $0.trailing.equalTo(dateLabel.snp.leading).offset(-20)
    }
    
    contentImageCollectionView.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(16)
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
      $0.leading.bottom.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(30)
    }
    
    likeButton.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    messagesContainer.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(likeContainer)
    }
    
    messagesButton.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.onReuse()
  }
  
  private func updateView() {
    guard let vm = self.viewModel else { return }
    self.nameLabel.text = vm.name
    self.storeNameLabel.text = vm.storeName
    self.containerListView.viewModel = .init(menus: vm.menus)
    self.likeButton.setImage(UIImage(named: vm.isLiked ? "icFeedLikeFilled": "icFeedLikeStroked"), for: .normal)
    self.likeButton.setTitle("\(vm.likeCount)", for: .normal)
    self.messagesButton.setTitle("\(vm.commentCount)", for: .normal)
    self.contentImageCollectionView.reloadData()
  }
  
  static func getHeight(viewModel: ViewModel) -> CGFloat {
    var height: CGFloat = 0
    let profileHeight: CGFloat = 79.0
    let contentImageViewHeight: CGFloat = UIScreen.main.bounds.size.width
    
    // containerList
    let containerListTop: CGFloat = 16
    let containerTitleHeight = getContainerTitleHeight()
    let containerBottmHeight: CGFloat = 8
    var containerHeight: CGFloat = 16
    let count = viewModel.menus.count
    containerHeight += CGFloat(18 * count)
    containerHeight += CGFloat(4 * (count - 1))
    containerHeight += containerListTop
    containerHeight += containerTitleHeight
    containerHeight += containerBottmHeight
    
    let likeMessagesTop: CGFloat = 21.0
    let likeMessagesHeight: CGFloat = 30.0
    
    height = profileHeight + contentImageViewHeight + containerHeight + likeMessagesTop + likeMessagesHeight
    return height
  }
  
  private static func getContainerTitleHeight() -> CGFloat {
    let containerTitleLabel = UILabel().then {
      $0.text = "용기정보"
      $0.font = .krTitle2
      $0.textColor = .systemGrayText01
    }
    return containerTitleLabel.getHeight()
  }
}

extension FeedListTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let vm = self.viewModel else { return 0 }
    return vm.imageList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let vm = self.viewModel,
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedContentCollectionViewCell.identifier, for: indexPath) as? FeedContentCollectionViewCell
    else { return .init() }
    let token = ImageDownloadManager.shared.downloadImage(with: vm.imageList[indexPath.item]) { image in
      cell.imageView.image = image
    }
    onReuse = {
      if let token = token {
        ImageDownloadManager.shared.cancelLoad(token)
      }
    }
    return cell
  }
}
