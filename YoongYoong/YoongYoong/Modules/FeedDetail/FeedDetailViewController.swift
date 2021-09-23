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
    $0.layer.cornerRadius = 19
    $0.layer.masksToBounds = true
    $0.isUserInteractionEnabled = true
  }
  
  let nameLabel = UILabel().then {
    $0.text = "김용기"
    $0.font = .krTitle2
    $0.textColor = .systemGrayText01
    $0.textAlignment = .left
  }
  
  let moreButton = UIButton().then {
    $0.setImage(UIImage(named: "icFeedDetailEdit"), for: .normal)
    $0.contentMode = .center
  }
  let moreContainer = UIStackView().then {
    $0.backgroundColor = .white
    $0.axis = .vertical
    $0.distribution = .fillEqually
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.systemGray06.cgColor
  }
  let editButton = UIButton().then {
    $0.setTitle("수정하기", for: .normal)
    $0.titleLabel?.font = .krBody2
    $0.setTitleColor(.systemGray01, for: .normal)
  }
  
  let deleteButton = UIButton().then {
    $0.setTitle("삭제하기", for: .normal)
    $0.titleLabel?.font = .krBody2
    $0.setTitleColor(.systemGray01, for: .normal)
  }
  
  let buttonDivider = UIView().then {
    $0.backgroundColor = .systemGray05
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
  
  
  let reportAction = PublishSubject<Void>()
  let banAction = PublishSubject<Void>()
  
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
    containerListView.layer.cornerRadius = 8
    containerListView.layer.borderWidth = 1
    containerListView.layer.borderColor = UIColor(hexString: "#ADADB1").cgColor
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
    
    let input = FeedDetailViewModel.Input(
      addComment: self.sendCommentButton.rx.tap.map { self.commentField.text ?? "" }.filter { !$0.isEmpty }.asObservable(),
      like: self.likeButton.rx.tap.asObservable(),
      edit: self.editButton.rx.tap.asObservable(),
      report: reportAction,
      ban: banAction
    )
    let output = viewModel.transform(input: input)
    output.feed.drive(onNext: { feed in
      if let url = feed.user.imageUrl {
        ImageDownloadManager.shared.downloadImage(url: url).bind(to: self.profileImageView.rx.image).disposed(by: self.disposeBag)
      }
      
      self.nameLabel.text = feed.user.nickname
      self.dateLabel.text = feed.createdDate
      self.storeNameLabel.text = feed.placeName
      self.likeButton.setImage(UIImage(named: feed.isLikePressed ? "icFeedLikeFilled": "icFeedLikeStroked"), for: .normal)
      self.likeButton.setTitle("\(feed.likeCount)", for: .normal)
      self.messagesButton.setTitle("\(feed.commentCount)", for: .normal)
      self.containerListView.viewModel = .init(menus: feed.postContainers)
    }).disposed(by: self.disposeBag)
    
    output.edit.subscribe(onNext: { viewModel in
      self.navigator.show(segue: .addReview(viewModel: viewModel), sender: self, transition: .navigation(.right, animated: true, hidesTabbar: true))
    }).disposed(by: disposeBag)
    
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
    
    moreButton.rx.tap.bind(onNext: { [weak self] in
      guard let self = self else { return }
      if globalUser.value.id != viewModel.currentFeed.value.user.id {
        self.showReportBanSheet()
      } else {
        self.moreContainer.isHidden = !self.moreContainer.isHidden
      }
      
    }).disposed(by: disposeBag)
    
    deleteButton.rx.tap.bind(onNext: {
      print("deleteButtonTapped")
      let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "삭제된 게시물은 보관되지 않습니다", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
        viewModel.deletePost()
      }))
      alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: .none))
      self.present(alert, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    viewModel.back.subscribe(onNext: { _ in
      self.navigationController?.popViewController(animated: true)
    }).disposed(by: disposeBag)
    
    if globalUser.value.id != viewModel.currentFeed.value.user.id {
      moreButton.setImage(UIImage(named: "icFeedDetailMore"), for: .normal)
    } else {
      moreButton.setImage(UIImage(named: "icFeedDetailEdit"), for: .normal)
    }
    
    output.login.subscribe(onNext: { [weak self] in
      self?.showLoginAlert()
    }).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    messagesTableView.dataSource = self
    messagesTableView.delegate = self
    
    contentImageCollectionView.dataSource = self
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
    
    self.view.addSubview(moreContainer)
    [editButton, deleteButton].forEach {
      moreContainer.addArrangedSubview($0)
    }
    moreContainer.addSubview(buttonDivider)
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
      $0.top.trailing.equalToSuperview()
      $0.width.height.equalTo(40)
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
    
    moreContainer.snp.makeConstraints {
      $0.top.equalTo(moreButton.snp.bottom)
      $0.trailing.equalTo(-15)
      $0.width.equalTo(86)
      $0.height.equalTo(88)
    }
    
    buttonDivider.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(8)
      $0.trailing.equalTo(-8)
      $0.height.equalTo(1)
    }
    
    moreContainer.isHidden = true
  }
  
  func showLoginAlert() {
    AlertAction.shared.showAlertView(title: "로그인이 필요한 서비스입니다.",description: "로그인 화면으로 이동하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: { [weak self] in
      LoginManager.shared.makeLogoutStatus()
      if let window = self?.view.window {
          self?.navigator.show(segue: .splash(viewModel: SplashViewModel()), sender: self, transition: .root(in: window))
      }
    })
  }
  
  func showReportBanSheet() {
    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
      self?.reportAction.onNext(())
    }
    let banAction = UIAlertAction(title: "차단하기", style: .default) { [weak self] _ in
      self?.banAction.onNext(())
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    [reportAction, banAction, cancelAction].forEach { sheet.addAction($0) }
    self.present(sheet, animated: true, completion: nil)
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
    guard let viewModel = self.viewModel as? FeedDetailViewModel else { return nil }
    let comment = viewModel.feedMessageElements.value[indexPath.row]
    guard comment.user.id == globalUser.value.id else {
      return nil
    }
    
    let editAction = UIContextualAction(style: .normal, title: nil) { action, view, completion in
        self.commentField.text = comment.content
        self.commentField.becomeFirstResponder()
        viewModel.commentMode.accept(.edit(comment.commentId))
      completion(true)
    }
    editAction.image = UIImage(named: "icFeedCommentEdit")
    editAction.backgroundColor = .brandColorTertiary01
    
    let removeAction = UIContextualAction(style: .normal, title: nil) {   action, view, completion in
      viewModel.deleteComment(commentId: comment.commentId)
      completion(true)
    }
    
    removeAction.image = UIImage(named: "icFeedCommentRemove")
    removeAction.backgroundColor = .brandColorSecondary01
    let config = UISwipeActionsConfiguration(actions: [editAction, removeAction])
    config.performsFirstActionWithFullSwipe = false
    return config
  }
}

extension FeedDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (self.viewModel as? FeedDetailViewModel)?.contentImageURL.value.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let vm = self.viewModel as? FeedDetailViewModel,
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedContentCollectionViewCell.identifier, for: indexPath) as? FeedContentCollectionViewCell else { return .init() }
    let token = ImageDownloadManager.shared.downloadImage(with: vm.contentImageURL.value[indexPath.item]) { image in
      cell.imageView.image = image
    }
    
    cell.onReuse = {
      if let token = token {
        ImageDownloadManager.shared.cancelLoad(token)
      }
    }
    return cell
  }
}
