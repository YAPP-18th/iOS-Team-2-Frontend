//
//  FeedProfileViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class FeedProfileViewController: ViewController {
  let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = .systemGray04
  }
  
  let nicknameLabel = UILabel().then {
    $0.text = "김용기"
    $0.font = .krTitle1
    $0.textColor = .systemGray01
  }
  
  let badgeButton = UIButton().then {
    $0.setTitle("배지", for: .normal)
    $0.titleLabel?.font = .krBody3
    $0.setTitleColor(.systemGrayText02, for: .normal)
  }
  
  let stateLabel = UILabel().then {
    $0.text = "안녕하세요"
    $0.numberOfLines = 0
    $0.font = .krBody2
    $0.textColor = .systemGrayText01
  }
  
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.backgroundColor = .white
    $0.register(ProfilePostCollectionViewCell.self, forCellWithReuseIdentifier: "ProfilePostCollectionViewCell")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    profileImageView.layer.cornerRadius = 25
    profileImageView.layer.masksToBounds = true
  }
  
  override func setupView() {
    super.setupView()
    [profileImageView, nicknameLabel, badgeButton, stateLabel, collectionView].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(36)
      $0.leading.equalTo(20)
      $0.width.height.equalTo(50)
    }
    
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(14)
    }
    
    badgeButton.snp.makeConstraints {
      $0.trailing.equalTo(-28)
      $0.centerY.equalTo(nicknameLabel)
    }
    
    badgeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    stateLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(14)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(34)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel as? FeedProfileViewModel else { return }
    let input = FeedProfileViewModel.Input(badge: self.badgeButton.rx.tap.asObservable())
    let output = viewModel.transform(input: input)
    
    output.profile.drive(onNext: { userInfo in
      self.nicknameLabel.text = userInfo.nickname
      ImageDownloadManager.shared.downloadImage(url: userInfo.imageUrl).bind(to: self.profileImageView.rx.image).disposed(by: self.disposeBag)
      self.stateLabel.text = userInfo.introduction
    }).disposed(by: self.disposeBag)
    let dataSource = RxCollectionViewSectionedReloadDataSource<ProfilePostListSection> { (dataSource, collectionView, indexPath, item) in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostCollectionViewCell", for: indexPath) as! ProfilePostCollectionViewCell
      cell.bind(to: item)
      return cell
    }
    
    output.items.asObservable()
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    
    output.badge.bind(onNext: { [weak self] viewModel in
      guard let self = self else { return }
      self.navigator.show(segue: .badgeList(viewModel: viewModel), sender: self, transition: .cover)
      
    }).disposed(by: disposeBag)
  }
}

extension FeedProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.size.width / 3
    let height = width
    return .init(width: width, height: height)
  }
}
