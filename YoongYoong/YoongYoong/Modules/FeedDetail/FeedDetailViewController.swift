//
//  FeedDetailViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit
import SnapKit
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
  
  lazy var contentImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      layout.sectionInset = .zero
      
      let width = UIScreen.main.bounds.size.width
      layout.itemSize = .init(width: width, height: width)
    }
    $0.register(FeedContentCollectionViewCell.self, forCellWithReuseIdentifier: FeedContentCollectionViewCell.identifier)
    $0.isPagingEnabled = true
    $0.backgroundColor = .systemGray00
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
  
  let tableViewDivider = UIView().then {
    $0.backgroundColor = .systemGray06
  }
  
  let messagesTableView = DynamicHeightTableView().then {
    $0.register(FeedDetailMessageTableViewCell.self, forCellReuseIdentifier: FeedDetailMessageTableViewCell.identifier)
    $0.separatorStyle = .none
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
  
  var commentFieldBotton: Constraint!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForKeyboardNotifications()
    (viewModel as? FeedDetailViewModel)?.fetchCommentList()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    resignForKeyboardNotifications()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.commentInputContainer.layer.applySketchShadow(color: .black, alpha: 0.07, x: 0, y: -2, blur: 8, spread: 0)
  }
  
  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(notification:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(notification:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func resignForKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc
  private func keyboardToggled(notification: NSNotification) {
    // Adjust the presented view to move the active text input out of the keyboards's way (if needed).
    if notification.name == UIResponder.keyboardWillShowNotification {
      guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      else { return assertionFailure() }

      let offset = ((keyboardFrame.height - self.view.safeAreaInsets.bottom) * -1) - 20
      self.commentFieldBotton.update(offset: offset)
    } else if notification.name == UIResponder.keyboardWillHideNotification {
      self.commentFieldBotton.update(offset: -20)
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? FeedDetailViewModel else { return }
    let input = FeedDetailViewModel.Input(addComment: self.sendCommentButton.rx.tap.map { self.commentField.text ?? "" }.filter { !$0.isEmpty }.asObservable() )
    let output = viewModel.transform(input: input)
    output.feed.drive(onNext: { feed in
      ImageDownloadManager.shared.downloadImage(url: feed.user.imageUrl).bind(to: self.profileImageView.rx.image).disposed(by: self.disposeBag)
      self.nameLabel.text = feed.user.nickname
      self.dateLabel.text = feed.createdDate
      self.storeNameLabel.text = feed.placeName
      self.likeButton.setTitle("\(feed.likeCount)", for: .normal)
      self.messagesButton.setTitle("\(feed.commentCount)", for: .normal)
    }).disposed(by: self.disposeBag)
    
    viewModel.feedMessageElements
      .observeOn(MainScheduler.instance)
      .bind(onNext: { _ in
      self.messagesTableView.reloadData()
    })
      .disposed(by: self.disposeBag)
    
    viewModel.commentAddSuccess
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
      self.commentField.text = ""
    }).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    messagesTableView.dataSource = self
    messagesTableView.delegate = self
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(scrollView)
    self.view.addSubview(commentInputContainer)
    scrollView.addArrangedSubview(contentView)
    
    [authorContainer, contentImageCollectionView, containerTitleLabel, containerListView, divider, likeContainer, messagesContainer, tableViewDivider, messagesTableView].forEach {
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
      self.commentFieldBotton = $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20).constraint
      $0.leading.equalTo(16)
      $0.top.equalTo(4)
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
    
    tableViewDivider.snp.makeConstraints {
      $0.top.equalTo(messagesContainer.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(4)
    }
    
    messagesTableView.snp.makeConstraints {
      $0.top.equalTo(tableViewDivider.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension FeedDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (viewModel as? FeedDetailViewModel)?.feedMessageElements.value.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let vm = viewModel as? FeedDetailViewModel,
          let cell = tableView.dequeueReusableCell(withIdentifier: FeedDetailMessageTableViewCell.identifier, for: indexPath) as? FeedDetailMessageTableViewCell else { return .init() }
    let item = vm.feedMessageElements.value[indexPath.row]
    cell.viewModel = .init(
      profileImage: item.user.imageUrl,
      name: item.user.nickname,
      message: item.content,
      date: item.createdDate
    )
    return cell
  }
}

extension FeedDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let vm = viewModel as? FeedDetailViewModel else { return .init() }
    let item = vm.feedMessageElements.value[indexPath.row]
    let viewModel = FeedDetailMessageTableViewCell.ViewModel(
      profileImage: item.user.imageUrl,
      name: item.user.nickname,
      message: item.content,
      date: item.createdDate
    )
    let height = FeedDetailMessageTableViewCell.getHeight(viewModel: viewModel)
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
      completion(true)
    }
    
    removeAction.image = UIImage(named: "icFeedCommentRemove")
    removeAction.backgroundColor = .brandColorSecondary01
    
    return UISwipeActionsConfiguration(actions: [editAction, removeAction])
  }
}
