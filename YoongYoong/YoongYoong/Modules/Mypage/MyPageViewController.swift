//
//  MyPageViewController.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RxDataSources

enum TabType: Int, CaseIterable{
  case badge
  case feed
  case history
  
  var title: String {
    switch self {
    case .badge:
      return "내 배지"
    case .feed:
      return "포스트"
    case .history:
      return "용기 보관함"
    }
  }
  
  var image: UIImage? {
    switch self {
    case .badge:
      return UIImage(named: "MyBadge-Inactive")
    case .feed:
      return UIImage(named: "MyPost-Inactive")
    case .history:
      return UIImage(named: "MyYonggi-Inactive")
    }
  }
  
  var selectedImage: UIImage? {
    switch self {
    case .badge:
      return UIImage(named: "MyBadge-Active")
    case .feed:
      return UIImage(named: "MyPost-Active")
    case .history:
      return UIImage(named: "MyYonggi-Active")
    }
  }
}

class MyPageViewController: ViewController {
  
  private let scrollView = ScrollStackView()
  private let containerView = UIView().then{
    $0.backgroundColor = .white
  }
  
  private let profileView = UIView().then{
    $0.backgroundColor = .white
  }
  
  // Login 되어 있을 경우의 뷰
  
  private let userContainer = UIView()
  
  private let profileImageView = UIImageView().then {
    $0.image = UIImage(named: "iconUserAvater")
    $0.layer.cornerRadius = 25
    $0.layer.masksToBounds = true
  }
  private let userNameLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 16, weight: .bold)
  }
  
  private let userIntroLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
  }
  
  private let editProfileBtn = UIButton().then {
    $0.setImage(UIImage(named: "EditProfileBtn"), for: .normal)
  }
  
  // Login 되어 있지 않을 경우의 뷰
  private let loginContainer = UIView()
  
  private let loginCircleView = UIView().then {
    $0.backgroundColor = .brandColorBlue01
    $0.layer.cornerRadius = 25
  }
  
  private let loginBtn = UIButton().then {
    $0.setTitle("로그인", for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.setTitleColor(.black, for: .normal)
  }
  
  private let rightArrowImageView = UIImageView().then {
    $0.image = UIImage(named: "icMyPageArrowRight")
    $0.contentMode = .scaleAspectFit
  }
  
  
  private let segmentView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
      let width = UIScreen.main.bounds.width / 3
      let height: CGFloat = 92
      layout.itemSize = .init(width: width, height: height)
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      layout.sectionInset = .zero
    }
    $0.backgroundColor = UIColor.brandColorTertiary01.withAlphaComponent(0.5)
    $0.register(MyPageSegmentCell.self, forCellWithReuseIdentifier: MyPageSegmentCell.identifier)
  }
  private lazy var collectionViewContainer = ScrollStackView().then {
    $0.stackView.axis = .horizontal
    $0.stackView.distribution = .fillEqually
    $0.stackView.alignment = .fill
    $0.containerView.snp.remakeConstraints {
      $0.leading.trailing.top.bottom.height.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width * 3)
    }
    $0.isScrollEnabled = false
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
  }
  
  let badgeDataSource = RxCollectionViewSectionedReloadDataSource<MyBadgeSection> { _, collectionView, indexPath, item in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBadgeCollectionViewCell.identifier, for: indexPath) as? MyBadgeCollectionViewCell else { return .init() }
    cell.bindCell(ImagePath: item.imagePath, title: item.title, collected: indexPath.item % 2 == 0)
    print(#function)
    return cell
  }
  
  private let badgeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.backgroundColor = .white
    $0.register(MyBadgeCollectionViewCell.self, forCellWithReuseIdentifier: MyBadgeCollectionViewCell.identifier)
    if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
      let width = UIScreen.main.bounds.width / 3
      let height: CGFloat = 145
      layout.scrollDirection = .vertical
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      layout.itemSize = .init(width: width, height: height)
    }
  }
  
  private let badgeEmptyView = UIView()
  private let badgeEmptyLabel = UILabel().then {
    $0.numberOfLines = 3
    $0.textAlignment = .center
    $0.font = .krBody2
    $0.text = """
              용기내용과 함께
              지구와 우리 모두를 위한
              용기를 내보아요
              """
    $0.textColor = .systemGrayText02
  }
  private let badgeEmptyImageView = UIImageView().then {
    $0.image = UIImage(named: "imgBadgeEmpty")
    $0.contentMode = .scaleAspectFit
  }
  
  private let postListView = MyPostView()
  
  private let yonggiCollectionView = MyPageYonggiView()
  
  private let leftButtonItem = UIBarButtonItem(
    image: UIImage(named: "Bellstroked"),
    style: .plain,
    target: self,
    action: #selector(showAlert)
  ).then{
    $0.tintColor = .black
  }
  private let rightButtonItem = UIBarButtonItem(
    image: UIImage(named: "Settingstroked"),
    style: .plain,
    target: self,
    action: #selector(showSetting)
  ).then{
    $0.tintColor = .black
  }
  private let yongyongView = MyPageYongYongView()
  var yongCommentList : [String] = ["용기를 내고 배지를 모아보세요",
                                    "지금까지 총 0개의 용기를 냈어요!",
                                    "자주 사용하는 용기를 등록하세요!"]
  let yongyongImg: [String] = ["yongyong1","yongyong2","yongyong3"]
  private let tabIndicator = UIView().then{
    $0.backgroundColor = .brandColorGreen03
    $0.frame.origin.x = CGFloat((UIScreen.main.bounds.width / 3.0 - 108)/2)
  }
  
  private var selectedTabIndex = 0 {
    didSet {
      let comment = self.yongCommentList[selectedTabIndex]
      let image = UIImage(named: self.yongyongImg[selectedTabIndex])
      self.yongyongView.viewModel = .init(image: image, comment: comment)
      
      let offset = UIScreen.main.bounds.width * CGFloat(selectedTabIndex)
      self.collectionViewContainer.setContentOffset(.init(x: offset, y: 0), animated: false)
    }
  }
  
  private let tabBinder = BehaviorSubject<[TabType]>(value: [.badge,.feed,.history])
  private let loadTrigger = PublishSubject<Void>()
  private let jumpTrigger = PublishSubject<Void>()
  private let loginTrigger = PublishSubject<Void>()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar(.white)
    self.navigationItem.leftBarButtonItem = leftButtonItem
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  
  override func configuration() {
    super.configuration()
    self.segmentView.dataSource = self
    self.segmentView.delegate = self
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabIndicator.frame.origin.x = CGFloat((UIScreen.main.bounds.width / 3.0 - 108)/2)
    if let viewModel = viewModel as? MypageViewModel {
      viewModel.getUserInfo()
    viewModel.getPostList()
    }
    
  }
  
  override func setupView() {
    self.view.addSubview(scrollView)
    scrollView.addArrangedSubview(containerView)
    [profileView, segmentView, yongyongView, collectionViewContainer].forEach {
      containerView.addSubview($0)
    }
    
    [badgeCollectionView, postListView, yonggiCollectionView].forEach {
      collectionViewContainer.addArrangedSubview($0)
    }
    
    [userContainer, loginContainer].forEach {
      profileView.addSubview($0)
    }
    
    [profileImageView, userNameLabel, userIntroLabel, editProfileBtn].forEach {
      userContainer.addSubview($0)
    }
    
    [loginCircleView, loginBtn, rightArrowImageView].forEach {
      loginContainer.addSubview($0)
    }
    
    badgeCollectionView.addSubview(badgeEmptyView)
    
    [badgeEmptyLabel, badgeEmptyImageView].forEach {
      badgeEmptyView.addSubview($0)
    }
  }
  
  override func setupLayout() {
    scrollView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    profileView.snp.makeConstraints{
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(117)
    }
    
    [userContainer, loginContainer].forEach {
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    
    // Login 되어있을 경우
    profileImageView.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(16)
      $0.width.height.equalTo(50)
    }
    
    userNameLabel.snp.makeConstraints{
      $0.top.equalTo(profileImageView.snp.top)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(14)
    }
    
    userIntroLabel.snp.makeConstraints{
      $0.leading.equalTo(userNameLabel.snp.leading)
      $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
    }
    
    editProfileBtn.snp.makeConstraints{
      $0.trailing.top.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    // Login 되어 있지 않을 경우
    loginCircleView.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(50)
    }
    
    loginBtn.snp.makeConstraints{
      $0.centerY.equalTo(loginCircleView)
      $0.leading.equalTo(loginCircleView.snp.trailing).offset(6)
    }
    
    rightArrowImageView.snp.makeConstraints {
      $0.centerY.equalTo(loginBtn)
      $0.leading.equalTo(loginBtn.snp.trailing).offset(8)
      $0.width.height.equalTo(24)
    }
    
    segmentView.snp.makeConstraints{
      $0.top.equalTo(profileView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(92)
    }
    
    yongyongView.snp.makeConstraints{
      $0.top.equalTo(segmentView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(60)
    }
    
    collectionViewContainer.snp.makeConstraints{
      $0.top.equalTo(yongyongView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    badgeEmptyView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.centerX.equalTo(self.view)
    }
    
    badgeEmptyLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(60)
    }
    
    badgeEmptyImageView.snp.makeConstraints {
      $0.top.equalTo(badgeEmptyLabel.snp.bottom).offset(18)
      $0.centerX.equalToSuperview()
    }
  }
  override func bindViewModel() {
    guard let viewModel = viewModel as? MypageViewModel else { return }
    let input = MypageViewModel.Input(
      containerSelect: .empty(),
      selectBadge: self.badgeCollectionView.rx.itemSelected.asObservable())
    let output = viewModel.transform(input: input)
    let login = viewModel.logIn(inputs: loginTrigger)
    
    editProfileBtn.rx.tap.bind{ [weak self] in
      guard let self = self else { return }
      let viewModel = EditProfileViewModel()
      self.navigator.show(segue: .editProfile(viewModel: viewModel), sender: self, transition: .navigation(.right, animated: true, hidesTabbar: true))
    }.disposed(by: disposeBag)
    leftButtonItem.rx.tap.bind{ [weak self] in
      if LoginManager.shared.isLogin {
        self?.navigator.show(segue: .alertList(viewModel: AlertViewModel()), sender: self, transition: .navigation())
      }
      else {
        self?.checkLogin()
      }
    }.disposed(by: disposeBag)
    rightButtonItem.rx.tap.bind{ [weak self] in
      if LoginManager.shared.isLogin {
        
        self?.navigator.show(segue: .settingList(viewModel: SettingViewModel()), sender: self, transition: .navigation())
      }
      else {
        self?.checkLogin()
      }
    }.disposed(by: disposeBag)
    loginBtn.rx.tap.bind(to: loginTrigger).disposed(by: disposeBag)
    login.bind{[weak self] in
      guard let self = self else {return}
      if let window = self.view.window {
        self.navigator.show(segue: .splash(viewModel: $0), sender: self, transition: .root(in: window))
      }
    }.disposed(by: disposeBag)
    let badgeResult = output.badgeList.asObservable().share(replay: 1)
      
    badgeResult.bind(to: badgeCollectionView.rx.items(dataSource: badgeDataSource)).disposed(by: disposeBag)
    badgeResult.subscribe(onNext: { badgeList in
      self.badgeEmptyView.isHidden = !badgeList[0].items.isEmpty
    }).disposed(by: self.disposeBag)
    output.containers.bind(to: yonggiCollectionView.tableView.rx.items(dataSource: yonggiCollectionView.datasource)).disposed(by: self.disposeBag)
    output.selectedBadge.subscribe(onNext: { badge in
      showBadgeDetailView.shared.showBadge(image: badge.imagePath, title: badge.title, description: badge.discription, condition: badge.condition)
    }).disposed(by: disposeBag)
    
    viewModel.postList.subscribe(onNext: { model in
      self.postListView.bindCell(model: model)
    }).disposed(by: disposeBag)
    
    globalUser
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] userInfo in
        guard let self = self else { return }
        if userInfo.id == 0 {
            self.setLogoutStatus()
        } else {
            self.setUserData(userInfo)
        }
      }).disposed(by: self.disposeBag)
    
    postListView.didSelectPost = { post in
      let viewModel = FeedDetailViewModel(feed: post)
      self.navigator.show(segue: .feedDetail(viewModel: viewModel), sender: self, transition: .navigation(.right, animated: true, hidesTabbar: true))
    }
    
    postListView.didTapNextMonth = {
      let currentMonth = viewModel.currentMonth.value
      let nextMonth = min(12, currentMonth + 1)
      viewModel.changeCurrentMonth(for: nextMonth)
    }
    
    postListView.didTapLastMonth = {
      let currentMonth = viewModel.currentMonth.value
      let lastMonth = max(1, currentMonth - 1)
      viewModel.changeCurrentMonth(for: lastMonth)
    }
  }
  
}
//MARK: -Selector
extension MyPageViewController {
  @objc
  func showAlert(sender: UIBarButtonItem) {
    print("알림 뷰로 갑니다")
  }
  @objc
  func showSetting(sender: UIBarButtonItem) {
    print("세팅으로갑니다.")
  }
  private func moveColletionViewNextPage(tabIndex:Int) {
//    UIView.animate(withDuration: 0.2) {
//      self.collectionView.contentOffset.x = CGFloat(tabIndex) * CGFloat(UIScreen.main.bounds.width)
//    }
  }
  private func checkLogin() {
    if !LoginManager.shared.isLogin {
      AlertAction.shared.showAlertView(title: "로그인이 필요한 서비스입니다.",description: "로그인 화면으로 이동하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: { [weak self] in
        self?.loginTrigger.onNext(())
      })
    }
  }
    
    private func setUserData(_ user: UserInfo) {
      self.loginContainer.isHidden = true
      self.userContainer.isHidden = false
        ImageDownloadManager.shared.downloadImage(url: user.imageUrl).asDriver(onErrorJustReturn: UIImage(named: "icPostThumbnail")!).drive(self.profileImageView.rx.image)
          .disposed(by: self.disposeBag)
        self.userNameLabel.text = user.nickname
        self.userIntroLabel.text = user.introduction
    }
    
    private func setLogoutStatus() {
      self.loginContainer.isHidden = false
      self.userContainer.isHidden = true
    }
}

extension MyPageViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TabType.allCases.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageSegmentCell.identifier, for: indexPath) as? MyPageSegmentCell else { return .init() }
    let tab = TabType.allCases[indexPath.item]
    let title = tab.title
    if indexPath.item == self.selectedTabIndex {
      let image = tab.selectedImage
      let textColor: UIColor = .black
      cell.viewModel = .init(image: image, title: title, textColor: textColor)
    } else {
      let image = tab.image
      let textColor: UIColor = .white
      cell.viewModel = .init(image: image, title: title, textColor: textColor)
    }
    
    return cell
  }
}

extension MyPageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.segmentView {
      self.selectedTabIndex = indexPath.item
      collectionView.reloadData()
    }
  }
}
