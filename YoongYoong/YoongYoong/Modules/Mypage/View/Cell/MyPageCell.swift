//
//  MyPageCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/22.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
class MyPageCell : UICollectionViewCell {
  var viewModel: MypageViewModel!
  var type: TabType!

  private var collectionView : UICollectionView!
  private let loadUITrigger = PublishSubject<Void>()
  private let disposeBag = DisposeBag()
  func bind(){
    setUpCollectionView()
    layout()
    
    
    let input = MypageViewModel.Input(loadView: loadUITrigger)
    let out = viewModel.transform(input: input)
    switch type {
    case .badge:
      print("뱃지")
      out.badgeUsecase.bind(to: collectionView.rx.items(cellIdentifier: MyBadgeCollectionViewCell.identifier,
                                                        cellType: MyBadgeCollectionViewCell.self)) {row, data, cell in
        cell.bindCell(ImagePath: data.imagePath, title: data.title, collected: false)
      }.disposed(by: disposeBag)
      collectionView.rx.modelSelected(BadgeModel.self).bind{ [weak self] model in
        showBadgeDetailView.shared.showBadge(image: model.imagePath, title: model.title, description: model.discription, condition: model.condition)
      }.disposed(by:disposeBag)
    case .feed:
      print("피드")
    case .history:
      print("용기 보관함")
    case .none:
      print("기타")
    }
    
    loadUITrigger.onNext(())
  }
  private func layout() {
    self.contentView.add(collectionView)
    collectionView.snp.makeConstraints{
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let width = UIScreen.main.bounds.width / 3.0 - 20
    layout.itemSize = {
      switch self.type {
      case .badge:
        return CGSize(width: width, height: width + 50)
      default:
        return UICollectionViewFlowLayout.automaticSize
      }
    }()
    //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.minimumLineSpacing = 0
    layout.sectionInset = {
      switch self.type {
      case .badge:
        return UIEdgeInsets(top: 50, left: 16, bottom: 10, right: 16)
      default:
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
      }
    }()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = false
    collectionView.register(MyBadgeCollectionViewCell.self, forCellWithReuseIdentifier: MyBadgeCollectionViewCell.identifier)
    collectionView.register(MyPostCollectionViewCell.self, forCellWithReuseIdentifier: MyPostCollectionViewCell.identifier)
    collectionView.register(MyPackageCollectionViewCell.self, forCellWithReuseIdentifier: MyPackageCollectionViewCell.identifier)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.bounces = false
  }
}
