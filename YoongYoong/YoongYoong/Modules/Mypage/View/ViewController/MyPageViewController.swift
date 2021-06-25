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
  private let profileView = UIView().then{
    $0.backgroundColor = .white
  }
  private let scrollView = ScrollStackView()
  private let containerView = UIView().then{
    $0.backgroundColor = .white
  }
  private let userProfile = UIImageView().then {
    $0.image = UIImage(named: "iconUserAvater")
  }
  private let userName = UILabel().then {
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 16, weight: .bold)
  }
  private let loginBtn = UIButton().then {
    $0.isHidden = true
    $0.setTitle("로그인", for: .normal)
    $0.titleLabel?.font = .sdGhothicNeo(ofSize: 18, weight: .regular)
    $0.setTitleColor(.black, for: .normal)
  }
  private let comments = UILabel().then {
    $0.numberOfLines = 2
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    
    
  }
  private let editProfileBtn = UIButton().then {
    $0.setImage(UIImage(named: "EditProfileBtn"), for: .normal)
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
  private var collectionView = UIView()
  
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
  private let yongyongView = UIView()
    .then{
      $0.backgroundColor = .brandColorGreen02
    }
  private let yongyong = UIImageView().then{
    $0.image = UIImage(named: "yongyong1")
    $0.backgroundColor = .clear
  }
  private let yongyongCommentView = UIView().then{
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.brandColorGreen01.cgColor
    $0.layer.cornerRadius = 16
  }
  private let yongyongCommentLable = UILabel().then{
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .center
  }
  var yongCommentList : [String] = ["용기를 내고 배지를 모아보세요",
                                    "지금까지 총 0개의 용기를 냈어요!",
                                    "자주 사용하는 용기를 등록하세요!"]
  let yongyongImg: [String] = ["yongyong1","yongyong2","yongyong3"]
  private let tabIndicator = UIView().then{
    $0.backgroundColor = .brandColorGreen03
    $0.frame.origin.x = CGFloat((UIScreen.main.bounds.width / 3.0 - 108)/2)
  }
  
  
  
  private var selectedTabIndex = 0
  
  private let tabBinder = BehaviorSubject<[TabType]>(value: [.badge,.feed,.history])
  private let loadTrigger = PublishSubject<Void>()
  private let jumpTrigger = PublishSubject<Void>()
  private let loginTrigger = PublishSubject<Void>()
  override func viewDidLoad() {
//    setupCollectionView()
    
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
    
  }
  
  override func setupView() {
    self.view.addSubview(scrollView)
    scrollView.addArrangedSubview(containerView)
    [profileView, segmentView, yongyongView, collectionView].forEach {
      containerView.addSubview($0)
    }
    
    [userProfile, userName, comments, editProfileBtn].forEach {
      profileView.addSubview($0)
    }
    [yongyong, yongyongCommentView].forEach {
      yongyongView.addSubview($0)
    }
    yongyongCommentView.addSubview(yongyongCommentLable)
  }
  
  override func setupLayout() {
    scrollView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    profileView.snp.makeConstraints{
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(117)
    }
    
    userProfile.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(16)
      $0.width.height.equalTo(50)
    }
    
    userName.snp.makeConstraints{
      $0.top.equalTo(userProfile.snp.top)
      $0.leading.equalTo(userProfile.snp.trailing).offset(14)
    }
    comments.snp.makeConstraints{
      $0.leading.equalTo(userName.snp.leading)
      $0.top.equalTo(userName.snp.bottom).offset(8)
    }
    editProfileBtn.snp.makeConstraints{
      $0.trailing.top.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    segmentView.snp.makeConstraints{
      $0.top.equalTo(profileView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(92)
    }
    
//    segmentView.add(tabIndicator)
    
//    tabIndicator.snp.makeConstraints{
//      $0.bottom.equalToSuperview()
//      $0.height.equalTo(4)
//      $0.width.equalTo(108)
//      $0.leading.greaterThanOrEqualToSuperview().offset(14)
//    }
    yongyongView.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(segmentView.snp.bottom)
    }
    
    yongyong.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(15)
      $0.height.equalTo(40)
      $0.width.equalTo(23)
    }
    yongyongCommentView.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(yongyong.snp.trailing).offset(19)
      $0.top.equalToSuperview().offset(14)
    }
    yongyongCommentLable.snp.makeConstraints{
      $0.centerX.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(8)
    }
    collectionView.snp.makeConstraints{
      $0.top.equalTo(yongyongView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    if !LoginManager.shared.isLogin {
      userName.isHidden = true
      userProfile.image = UIImage()
      comments.isHidden = true
      editProfileBtn.isHidden = true
      loginBtn.isHidden = false
      profileView.add(loginBtn)
      loginBtn.snp.makeConstraints{
        $0.centerY.equalTo(userProfile)
        $0.leading.equalTo(userProfile.snp.trailing).offset(6)
      }
    }
  }
  override func bindViewModel() {
    guard let viewModel = viewModel as? MypageViewModel else { return }
    let input = MypageViewModel.Input(loadView: loadTrigger, containerSelect: .empty() )
    let profile = viewModel.getProfile(inputs: input)
    let message = viewModel.yongyongMessage(inputs: input)
    let login = viewModel.logIn(inputs: loginTrigger)
    profile.drive{ [weak self] model in
      guard let self = self else{return}
      if let image = model.imagePath {
        self.userProfile.image = UIImage(named: image)
      }
      else {
        self.userProfile.image = UIImage(named: "iconUserAvater")
      }
      self.userName.text = model.name
      self.comments.text = model.message
    }.disposed(by: disposeBag)
    message.drive{ [weak self] message in
      self?.yongyongCommentLable.text = message
    }.disposed(by: disposeBag)
    
    editProfileBtn.rx.tap.bind{[weak self] in
      let vc = EditProfileViewController(viewModel: EditProfileViewModel(), navigator: self?.navigator ?? Navigator())
      vc.hidesBottomBarWhenPushed = true
      self?.navigationController?.pushViewController(vc, animated: true)
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
    self.loadTrigger.onNext(())
    
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

//extension MyPageViewController : UICollectionViewDelegateFlowLayout {
//  private func setupCollectionView() {
//    let offset = Int((UIScreen.main.bounds.width / 3.0 - 108)/2)
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .horizontal
//    layout.minimumLineSpacing = 0
//    layout.itemSize = UICollectionViewFlowLayout.automaticSize
//    layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collectionView.backgroundColor = .white
//    collectionView.isPagingEnabled = true
//    collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: MyPageCell.identifier)
//    collectionView.showsHorizontalScrollIndicator = false
//    collectionView.showsVerticalScrollIndicator = false
//    collectionView.bounces = false
//    collectionView.isHidden = false
//    collectionView.delegate = nil
//    collectionView.rx.setDelegate(self)
//      .disposed(by: disposeBag)
//    tabIndicator.frame.size.width = 108
//    tabIndicator.frame.origin.x = CGFloat(offset)
//    collectionView.rx.didScroll
//      .map{[unowned self] in self.collectionView.contentOffset.x}
//      .bind(onNext: { [unowned self] in
//        let itemIndex = Int(($0 / UIScreen.main.bounds.width).rounded())
//        let indicatorWidth = 108
//        UIView.animate(withDuration: 0.2) {
//          self.segmentView.selectItem(at: IndexPath(item: itemIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
//          tabIndicator.frame.origin.x = CGFloat(itemIndex) * (CGFloat(indicatorWidth + offset * 2)) + CGFloat(offset)
//          self.view.layoutIfNeeded()
//        }
//        self.yongyongCommentLable.text = yongCommentList[itemIndex]
//      })
//      .disposed(by: disposeBag)
//  }
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let width = collectionView.frame.width
//    let height = collectionView.frame.height
//    return CGSize(width: width, height: height)
//  }
//  @objc
//  private func login(sender : UITapGestureRecognizer) {
//    self.loginTrigger.onNext(())
//  }
  
//}


