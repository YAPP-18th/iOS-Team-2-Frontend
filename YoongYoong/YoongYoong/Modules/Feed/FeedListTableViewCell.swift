//
//  FeedListTableViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/21.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class FeedListTableViewCell: UITableViewCell {
  private var bag = DisposeBag()
  
  let dataSource = RxCollectionViewSectionedAnimatedDataSource<FeedContentImageSection> { _, collectionView, indexPath, viewModel in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedContentCollectionViewCell.identifier, for: indexPath) as? FeedContentCollectionViewCell else { return .init() }
    cell.bind(to: viewModel)
    return cell
  }
  
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
  
  func bind(to viewModel: FeedListTableViewCellViewModel) {
    viewModel.nickname.asDriver().drive(self.nameLabel.rx.text).disposed(by: bag)
    viewModel.storeName.asDriver().drive(self.storeNameLabel.rx.text).disposed(by: bag)
    viewModel.date.asDriver().drive(self.dateLabel.rx.text).disposed(by: bag)
    viewModel.likePressed.asDriver().drive(onNext: { isLikePressed in
      self.likeButton.setImage(UIImage(named: isLikePressed ? "icFeedLikeFilled" : "icFeedLikeStroked"), for: .normal)
    }).disposed(by: bag)
    let containerViewModel = FeedListContainerListViewModel(with: viewModel.containerList.value)
    viewModel.profileImageURL.subscribe (onNext: { url in
      guard let url = url else { return }
      ImageDownloadManager.shared.downloadImage(url: url).bind(to: self.profileButton.rx.image(for: .normal)).disposed(by: self.bag)
    }).disposed(by: bag)
    contentImageCollectionView.dataSource = nil
    viewModel.contentImageURL.map { list -> [FeedContentImageSection] in
      var elements: [FeedContentImageSection] = []
      let cellViewModel = list.map { url -> FeedContentImageSection.Item in
        FeedContentCollectionViewCellViewModel.init(imageURL: url)
      }
      elements.append(FeedContentImageSection(items: cellViewModel))
      return elements
    }.bind(to: contentImageCollectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
    viewModel.likecount.bind(to: likeButton.rx.title(for: .normal)).disposed(by: bag)
    viewModel.messageCount.bind(to: messagesButton.rx.title(for: .normal)).disposed(by: bag)
    containerListView.bind(to: containerViewModel)
    
    profileButton.rx.tap
      .bind(to: viewModel.userSelection)
      .disposed(by: self.bag)
    
    likeButton.rx.tap
      .bind(to: viewModel.likeButtonDidTap)
      .disposed(by: self.bag)
  }
}

extension FeedListTableViewCell {
  private func configuration() {
    self.selectionStyle = .none
    self.contentView.backgroundColor = .systemGray00
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
      $0.top.equalTo(25)
      $0.leading.equalTo(profileButton.snp.trailing).offset(8)
      $0.height.equalTo(18)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(2)
      $0.trailing.equalTo(-15)
    }
    
    dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    storeNameLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(2)
      $0.leading.equalTo(profileButton.snp.trailing).offset(8)
      $0.trailing.equalTo(dateLabel.snp.leading).offset(-20)
      $0.height.equalTo(18)
    }
    
    contentImageCollectionView.snp.makeConstraints {
      $0.top.equalTo(storeNameLabel.snp.bottom).offset(16)
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
      $0.leading.bottom.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(30)
    }
    
    likeButton.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    messagesContainer.snp.makeConstraints {
      $0.top.equalTo(containerListView.snp.bottom).offset(21)
      $0.trailing.bottom.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(30)
    }
    
    messagesButton.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.bag = DisposeBag()
  }
  
  private func updateView() {
    
  }
  
  static func getHeight(viewModel: FeedListTableViewCellViewModel) -> CGFloat {
    var height: CGFloat = 0
    let profileHeight: CGFloat = 79.0
    let contentImageViewHeight: CGFloat = UIScreen.main.bounds.size.width
    var containerHeight: CGFloat = 35.0 + 24.0 + 21.0
    let count = viewModel.containerList.value.count
    containerHeight += CGFloat(18 * count)
    
      
    let likeMessagesHeight: CGFloat = 30.0
    
    height = profileHeight + contentImageViewHeight + containerHeight + likeMessagesHeight
    return height
  }
}
