//
//  StoreViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit
import RxSwift
import RxCocoa

class StoreViewController: ViewController {
  let vStackView = ScrollStackView().then {
//    $0.contentInsetAdjustmentBehavior = .never
    $0.contentInset.bottom = 88
  }
  private let topContainerView = UIView().then {
    $0.backgroundColor = .brandColorTertiary01
  }
  private let backButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavBackWhite"), for: .normal)
    $0.contentMode = .center
  }
  
  private let nameLabel = UILabel().then {
    $0.text = "김밥나라"
    $0.textColor = .white
    $0.font = .krDisplay
  }
  
  private let distanceLabel = UILabel().then {
    $0.text = "600m"
    $0.textColor = .white
    $0.font = .krTitle1
  }
  
  private let locationImageView = UIImageView().then {
    $0.image = UIImage(named: "icStorePin")
  }
  
  private let addressLabel = UILabel().then {
    $0.text = "서울 송파구 송파대로 106-17"
    $0.font = .krBody2
    $0.textColor = .white
  }
  
  private let yonggiView = StoreYonggiView()
  private let yonggiCommentView = StoreYonggiCommentView()
  
  let tableViewContainer = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let emptyImageView = UIImageView().then {
    $0.image = UIImage(named: "icStorePostEmpty")
    $0.contentMode = .scaleAspectFit
  }
  
  private let emptyLabel = UILabel().then {
    $0.text = "첫 포스트를 남겨보세요"
    $0.font = .krBody2
    $0.textColor = .systemGray02
  }
  
  private let tableView = DynamicHeightTableView().then {
    $0.backgroundColor = .clear
    $0.register(StoreReviewCell.self, forCellReuseIdentifier: StoreReviewCell.identifier)
    $0.separatorColor = .groupTableViewBackground
    $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  private let postButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.setTitle("이 가게 포스트 쓰기", for: .normal)
    $0.backgroundColor = .brandColorGreen01
    $0.contentVerticalAlignment = .top
    $0.titleEdgeInsets = UIEdgeInsets(top: 10.0,
                                      left: 0.0,
                                      bottom: 0.0,
                                      right: 0.0)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    
    guard let viewModel = self.viewModel as? StoreViewModel else { return }
    viewModel.getContainerInfo()
    viewModel.getPostList()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    postButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    postButton.layer.cornerRadius = 16.0
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .systemGray06
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(vStackView)
    self.view.addSubview(postButton)
    
    vStackView.backgroundColor = .brandColorTertiary01
    yonggiView.backgroundColor = .white
    yonggiCommentView.backgroundColor = .white
    tableViewContainer.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    
    [topContainerView, yonggiView, yonggiCommentView, tableViewContainer].forEach {
      vStackView.addArrangedSubview($0)
    }
    
    [backButton, nameLabel, distanceLabel, locationImageView, addressLabel].forEach {
      topContainerView.addSubview($0)
    }
    
    [emptyImageView, emptyLabel, tableView].forEach {
      tableViewContainer.addSubview($0)
    }
  }
  
  override func setupLayout() {
    vStackView.snp.makeConstraints {
      $0.edges.bottom.equalToSuperview()
    }
    
    backButton.snp.makeConstraints {
      $0.top.equalTo(16)
      $0.leading.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(backButton.snp.bottom).offset(24)
      $0.leading.equalTo(16)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(12)
      $0.leading.equalTo(16)
    }
    
    locationImageView.snp.makeConstraints {
      $0.top.equalTo(distanceLabel.snp.bottom).offset(12)
      $0.leading.equalTo(16)
      $0.width.height.equalTo(20)
      $0.bottom.equalTo(-52)
    }
    
    addressLabel.snp.makeConstraints {
      $0.leading.equalTo(locationImageView.snp.trailing).offset(2)
      $0.centerY.equalTo(locationImageView)
    }
    
    postButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(88)
    }
    
    emptyImageView.snp.makeConstraints {
      $0.top.equalTo(88)
      $0.centerX.equalToSuperview()
    }
    
    tableViewContainer.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(500)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImageView.snp.bottom).offset(26)
      $0.centerX.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? StoreViewModel else { return }
    let input = StoreViewModel.Input(
      post: self.postButton.rx.tap.asObservable()
    )
    let output = viewModel.transform(input: input)
    
    output.place.drive(onNext: { place in
      self.nameLabel.text = place.name
      self.distanceLabel.text = place.distance + "m"
      self.addressLabel.text = place.address
    }).disposed(by: disposeBag)
    
    output.imageSelectionView
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] viewModel in
        self?.navigator.show(segue: .selectImage(viewModel: viewModel), sender: self, transition: .navigation())
      }).disposed(by: disposeBag)
    
    output.setting
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.showPermissionAlert()
      }).disposed(by: disposeBag)
    
    output.login.subscribe(onNext: { [weak self] in
      self?.showLoginAlert()
    }).disposed(by: disposeBag)
    
    viewModel.postList
      .observeOn(MainScheduler.instance)
        .subscribe(onNext: { list in
            self.yonggiCommentView.commentLabel.text = "지금까지 총 \(list.count)개의 용기를 냈어요"
        self.tableView.reloadData()
      }).disposed(by: self.disposeBag)
    
    viewModel.detail.subscribe(onNext: { viewModel in
      self.navigator.show(segue: .feedDetail(viewModel: viewModel), sender: self, transition: .navigation(.right, animated: true, hidesTabbar: true))
    }).disposed(by: self.disposeBag)
    self.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    viewModel.containerList.subscribe(onNext: { item in
        let list = item.map { StoreYonggiItemView.ViewModel(container: (.init(rawValue: $0.name) ?? .없음), size: $0.size) }
        self.yonggiView.viewModelList = list
    }).disposed(by: disposeBag)

  }
  
  private func showPermissionAlert() {
    let alertController = UIAlertController(title: nil, message: "사진 기능을 사용하려면 '사진' 접근권한을 허용해야 합니다.", preferredStyle: .alert)
    alertController.addAction(.init(title: "설정", style: .default, handler: { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }))
    alertController.addAction(.init(title: "취소", style: .cancel))
    self.present(alertController, animated: true)
  }
  
  @objc func back() {
    self.navigationController?.popViewController(animated: true)
  }
  
  func showLoginAlert() {
    AlertAction.shared.showAlertView(title: "로그인이 필요한 서비스입니다.",description: "로그인 화면으로 이동하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: { [weak self] in
      LoginManager.shared.makeLogoutStatus()
      if let window = self?.view.window {
          self?.navigator.show(segue: .splash(viewModel: SplashViewModel()), sender: self, transition: .root(in: window))
      }
    })
  }
}

extension StoreViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = (viewModel as? StoreViewModel)?.postList.value.count ?? 0
    self.emptyImageView.isHidden = count != 0
    self.emptyLabel.isHidden = count != 0
    tableView.separatorStyle = count == 0 ? .none : .singleLine
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreReviewCell.identifier, for: indexPath) as? StoreReviewCell,
          let viewModel = self.viewModel as? StoreViewModel else { return .init() }
    let item = viewModel.postList.value[indexPath.row]
    let menu = item.postContainers.map { "\($0.food) \($0.foodCount) "}.joined(separator: "/ ")
    cell.viewModel = .init(name: item.user.nickname, date: item.createdDate, menu: menu, content: item.content ?? "")
    let menuToken = ImageDownloadManager.shared.downloadImage(with: item.images[0]) { image in
      cell.menuImageView.image = image
    }
    if let url = item.user.imageUrl {
      let profileToken = ImageDownloadManager.shared.downloadImage(with: url) { image in
        cell.profileImageView.image = image
      }
      
      cell.onReuse = {
        if let profileToken = profileToken,
           let menuToken = menuToken {
          ImageDownloadManager.shared.cancelLoad(profileToken)
          ImageDownloadManager.shared.cancelLoad(menuToken)
        }
      }
    }
    
    
    
    
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel = self.viewModel as? StoreViewModel else { return }
    viewModel.goToFeedDetail(indexPath)
  }
}
