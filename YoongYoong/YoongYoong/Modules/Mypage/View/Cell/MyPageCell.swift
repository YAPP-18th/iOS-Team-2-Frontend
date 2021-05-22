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
      out.postUsecase.map{[$0]}.bind(to: collectionView.rx.items(cellIdentifier: MyPostCollectionViewCell.identifier,
                                                       cellType: MyPostCollectionViewCell.self)) {row, data, cell in
        cell.bindCell(model: data)

        cell.nextMonthBtn.rx.tap
          .takeUntil(cell.rx.methodInvoked(#selector(UICollectionReusableView.prepareForReuse)))
          .bind{
            print("다음 달 탭")
          }.disposed(by: cell.disposeBag)
        cell.lastMonthBtn.rx.tap
          .takeUntil(cell.rx.methodInvoked(#selector(UICollectionReusableView.prepareForReuse)))
          .bind{
            print("저번 달 탭")
          }.disposed(by: cell.disposeBag)
      }.disposed(by: disposeBag)
    case .history:
      out.packageUsecase.map{[$0]}.bind(to: collectionView.rx.items(cellIdentifier: MyPackageCollectionViewCell.identifier,
                                                                    cellType: MyPackageCollectionViewCell.self)) {row, data, cell in
        cell.setupCollectionView()
        cell.setupTableView()
        cell.bindCell(model: data)
      }.disposed(by: disposeBag)
      
      print("용기 보관함")
    case .none:
      print("기타")
    }
    if let topView = UIApplication.shared.topViewController() as? MyPageViewController {
      out.messageIndicator.bind{ [weak self] str in
        topView.yongCommentList = str
      }.disposed(by: disposeBag)
    }
    
   
    loadUITrigger.onNext(())
  }
  private func layout() {
    self.contentView.add(collectionView)
    collectionView.snp.makeConstraints{
      $0.top.leading.trailing.bottom.equalToSuperview()
//      $0.height.equalTo(600)
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
      case .feed:
        return CGSize(width: UIScreen.main.bounds.width, height: UICollectionViewFlowLayout.automaticSize.height)
      case .history:
        return CGSize(width: UIScreen.main.bounds.width, height: UICollectionViewFlowLayout.automaticSize.height)
      default:
        return UICollectionViewFlowLayout.automaticSize
      }
    }()
    layout.estimatedItemSize = {
      switch self.type {
      case .badge:
        return CGSize(width: width, height: width + 50)
      case .feed:
        return CGSize(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
      case .history:
        return CGSize(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)

      default:
        return UICollectionViewFlowLayout.automaticSize
      }
    }()
    layout.minimumLineSpacing = 0
    layout.sectionInset = {
      switch self.type {
      case .badge:
        return UIEdgeInsets(top: 50, left: 16, bottom: 10, right: 16)
      case .feed:
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      case .history:
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

      default:
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
      }
    }()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = false
    switch self.type {
    case .badge:
      collectionView.isScrollEnabled = true
    case .feed:
      collectionView.isScrollEnabled = true
    case .history:
      collectionView.isScrollEnabled = true

    default:
      collectionView.isScrollEnabled = false
    }
    collectionView.register(MyBadgeCollectionViewCell.self, forCellWithReuseIdentifier: MyBadgeCollectionViewCell.identifier)
    collectionView.register(MyPostCollectionViewCell.self, forCellWithReuseIdentifier: MyPostCollectionViewCell.identifier)
    collectionView.register(MyPackageCollectionViewCell.self, forCellWithReuseIdentifier: MyPackageCollectionViewCell.identifier)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.bounces = true
  }
}
