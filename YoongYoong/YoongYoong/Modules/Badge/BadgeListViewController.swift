//
//  BadgeListViewController.swift
//  용기내용
//
//  Created by 손병근 on 2021/07/31.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class BadgeListViewController: ViewController {
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
  }
  
  let titleView = UIView().then {
    $0.backgroundColor = .brandColorGreen01
  }
  
  let titleLabel = UILabel().then {
    $0.font = .krBody1
    $0.textColor = .white
  }
  
  let closeButton = UIButton().then {
    $0.setImage(UIImage(named: "btnBadgeClose"), for: .normal)
    $0.contentMode = .center
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    guard let viewModel = self.viewModel as? BadgeListViewModel else { return }
  
    let output = viewModel.transform(input: BadgeListViewModel.Input())
    output.user.subscribe(onNext: { [weak self] user in
      let nickname = user.nickname
      let attrText = NSMutableAttributedString()
        .string(nickname, font: .krBody1, color: .white)
        .string("님의 배지", font: .krTitle1, color: .white)
      self?.titleLabel.attributedText = attrText
    }).disposed(by: disposeBag)
    output.badgeList.drive(badgeCollectionView.rx.items(dataSource: badgeDataSource)).disposed(by: disposeBag)
  }
  
  override func configuration() {
    self.view.backgroundColor = .black.withAlphaComponent(0.7)
    self.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
  }
  
  override func setupView() {
    self.view.addSubview(containerView)
    [titleView, badgeCollectionView].forEach {
      containerView.addSubview($0)
    }
    
    [titleLabel, closeButton].forEach {
      titleView.addSubview($0)
    }
  }
  
  override func setupLayout() {
    containerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(64)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    titleView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(57)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    closeButton.snp.makeConstraints {
      $0.top.equalTo(5)
      $0.trailing.equalTo(-3)
      $0.width.height.equalTo(40)
    }
    
    badgeCollectionView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  @objc func closeButtonTapped() {
    self.dismiss(animated: true, completion: nil)
  }
}
