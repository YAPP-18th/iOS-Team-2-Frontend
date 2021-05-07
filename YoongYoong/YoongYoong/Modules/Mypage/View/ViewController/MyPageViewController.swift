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
class MyPageViewController: ViewController {
  private let profileView = UIView().then{
    $0.backgroundColor = .white
  }
  private let scrollView = UIScrollView()
  private let containerView = UIView().then{
    $0.backgroundColor = .white
  }
  private let userProfile = UIImageView()
  private let userName = UILabel().then {
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 16, weight: .bold)
  }
  private let comments = UILabel().then {
    $0.numberOfLines = 2
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)

    
  }
  private let editProfileBtn = UIButton()
  private let segmentView = UIView().then {
    $0.backgroundColor = UIColor.brandColorTertiary01.withAlphaComponent(0.5)
  }
  private var collectionView: UICollectionView!
  
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
      $0.backgroundColor = .brandSecondary
    }
  private let yongyong = UIImageView().then{
    $0.image = UIImage(named: "")
    $0.backgroundColor = .gray
  }
  private let yongyongCommentView = UIView().then{
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.brandPrimary.cgColor
    $0.layer.cornerRadius = 16
  }
  private let yongyongCommentLable = UILabel().then{
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .center
  }
  var yongCommentList : [String] = []
  private let tabView : [UIView] = [UIView(),UIView(),UIView()]
  private let tabs : [UIImageView] = [UIImageView(),
                                      UIImageView(),
                                      UIImageView()]
  private let tabLabel : [UILabel] = [UILabel(),
                                      UILabel(),
                                      UILabel()]
  private let tabIndicator = UIView().then{
    $0.backgroundColor = .brandTertiary
    $0.frame.origin.x = CGFloat((UIScreen.main.bounds.width / 3.0 - 108)/2)
  }
  
  private let tabBinder = BehaviorSubject<[TabType]>(value: [.badge,.feed,.history])
  private let loadTrigger = PublishSubject<Void>()
  private let jumpTrigger = PublishSubject<Void>()
  override func viewDidLoad() {
    setupCollectionView()

    super.viewDidLoad()
    setupNavigationBar(.white)
    self.navigationItem.leftBarButtonItem = leftButtonItem
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabIndicator.frame.origin.x = CGFloat((UIScreen.main.bounds.width / 3.0 - 108)/2)

  }
  override func setupLayout() {
    self.view.add(scrollView)
    scrollView.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
    scrollView.add(containerView)
    containerView.snp.makeConstraints{
      $0.centerX.centerY.width.equalToSuperview()
      $0.height.equalToSuperview().priority(.low)
    }
    containerView.adds([profileView,
                    segmentView,
                    yongyongView,
                    collectionView])
    profileView.snp.makeConstraints{
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(15)
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
    }
    profileView.adds([userProfile, userName, comments, editProfileBtn])
    userProfile.snp.makeConstraints{
      $0.top.leading.equalToSuperview()
      $0.width.height.equalTo(50)
      $0.bottom.equalToSuperview().offset(-20)
    }
    userProfile.image = UIImage(named: "iconUserAvater")
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
    editProfileBtn.setImage(UIImage(named: "EditProfileBtn"), for: .normal)
    segmentView.snp.makeConstraints{
      $0.leading.centerX.equalToSuperview()
      $0.top.equalTo(profileView.snp.bottom).offset(16)
    }
    segmentView.adds(tabView)
    segmentView.add(tabIndicator)
    for (index, tab) in tabView.enumerated() {
      tab.isUserInteractionEnabled = true
      tab.tag = index
      tabView[index].adds([tabs[index],tabLabel[index]])
      tab.snp.makeConstraints{
        $0.centerX.equalToSuperview().offset(
          (UIScreen.main.bounds.width / 6.0) * CGFloat((index*2) - 2)
        )
        $0.top.bottom.equalToSuperview()
        $0.width.equalTo(UIScreen.main.bounds.width / 3.0)
        $0.height.equalTo(92)
      }
      tabs[index].snp.makeConstraints{
        $0.centerX.equalToSuperview()
        $0.top.equalToSuperview().offset(12)
        $0.width.height.equalTo(40)
      }
      tabLabel[index].snp.makeConstraints{
        $0.centerX.equalToSuperview()
        $0.top.equalTo(tabs[index].snp.bottom).offset(4)
      }
    }
    tabView[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab1Action)))
    tabView[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab2Action)))
    tabView[2].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab3Action)))

    tabIndicator.snp.makeConstraints{
      $0.bottom.equalToSuperview()
      $0.height.equalTo(4)
      $0.width.equalTo(108)
      $0.leading.greaterThanOrEqualToSuperview().offset(14)
    }
    yongyongView.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(segmentView.snp.bottom)
    }
    yongyongView.adds([yongyong, yongyongCommentView])
    yongyongCommentView.add(yongyongCommentLable)
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
      $0.width.equalTo(self.view.frame.width)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  override func bindViewModel() {
    guard let viewModel = viewModel as? MypageViewModel else { return }
    let input = MypageViewModel.Input(loadView: loadTrigger)
    let profile = viewModel.getProfile(inputs: input)
    let message = viewModel.yongyongMessage(inputs: input)
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
    
    self.tabBinder.bind(to: collectionView.rx.items(cellIdentifier: MyPageCell.identifier,
                                                    cellType: MyPageCell.self)){ row, data, cell in
      self.setTabView(tabIndex: row)
      cell.viewModel = viewModel
      cell.type = data
      cell.bind()

    }.disposed(by: disposeBag)
  editProfileBtn.rx.tap.bind{[weak self] in
      let vc = EditProfileViewController(viewModel: EditProfileViewModel(), navigator: self?.navigator ?? Navigator())
      vc.hidesBottomBarWhenPushed = true
      self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
    leftButtonItem.rx.tap.bind{
      print("알림뷰로")
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
  @objc
  private func tab1Action(sender : UITapGestureRecognizer) {
    setTabView(tabIndex: 0)
    moveColletionViewNextPage(tabIndex: 0)
  }
  @objc
  private func tab2Action(sender : UITapGestureRecognizer) {
    setTabView(tabIndex: 1)
    moveColletionViewNextPage(tabIndex: 1)
  }
  @objc
  private func tab3Action(sender : UITapGestureRecognizer) {
    setTabView(tabIndex: 2)
    moveColletionViewNextPage(tabIndex: 2)
  }
  private func setTabView(tabIndex i : Int) {
    // default, selected
    let tabImageName: [(String,String)] = [("MyBadge-Inactive","MyBadge-Active"),
                                           ("MyPost-Inactive","MyPost-Active"),
                                           ("MyYonggi-Inactive","MyYonggi-Active")]
    let tabName = ["내 배지", "포스트", "용기 보관함"]
    for idx in 0..<self.tabView.count {
      self.tabs[idx].image = UIImage(named: i == idx ? tabImageName[idx].1 : tabImageName[idx].0)
      self.tabLabel[idx].text = tabName[idx]
      self.tabLabel[idx].textColor = idx == i ? .black : .white
      self.tabLabel[idx].font = .sdGhothicNeo(ofSize: 12, weight: .bold)
    }
  }
  private func moveColletionViewNextPage(tabIndex:Int) {
      UIView.animate(withDuration: 0.2) {
          self.collectionView.contentOffset.x = CGFloat(tabIndex) * CGFloat(UIScreen.main.bounds.width)
      }
  }

}
extension MyPageViewController : UICollectionViewDelegateFlowLayout {
  private func setupCollectionView() {
    let offset = Int((UIScreen.main.bounds.width / 3.0 - 108)/2)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: MyPageCell.identifier)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.bounces = false
    collectionView.isHidden = false
    collectionView.rx.setDelegate(self)
        .disposed(by: disposeBag)
    tabIndicator.frame.size.width = 108
    tabIndicator.frame.origin.x = CGFloat(offset)
    collectionView.rx.didScroll
      .map{[unowned self] in self.collectionView.contentOffset.x}
      .bind(onNext: { [unowned self] in
        let itemIndex = Int(($0 / UIScreen.main.bounds.width).rounded())
        let indicatorWidth = 108
        UIView.animate(withDuration: 0.2) {
          setTabView(tabIndex: itemIndex)
          tabIndicator.frame.origin.x = CGFloat(itemIndex) * (CGFloat(indicatorWidth + offset * 2)) + CGFloat(offset)
          self.view.layoutIfNeeded()
        }
        self.yongyongCommentLable.text = yongCommentList[itemIndex]
      })
      .disposed(by: disposeBag)
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let height = collectionView.frame.height
    return CGSize(width: width, height: height)
  }
}
enum TabType{
  case badge
  case feed
  case history
}
