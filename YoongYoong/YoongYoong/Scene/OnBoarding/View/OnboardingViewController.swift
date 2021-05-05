//
//  OnboardingViewController.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
final class OnboradingViewController : ViewController{
  private var collectionView: UICollectionView!
  private var skipBtn = UIButton().then{
    $0.setTitle("건너뛰기", for: .normal)
    $0.setTitleColor(.darkGray, for: .normal)
    $0.backgroundColor = .white
  }
  private var pageController = UIPageControl().then{
    $0.numberOfPages = 5
    $0.pageIndicatorTintColor = .lightGray
    $0.currentPageIndicatorTintColor = .darkGray
  }
  private let startBtn = UIButton().then{
    $0.backgroundColor = .brandColorGreen01
    $0.setTitle("시작하기", for: .normal)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    $0.isHidden = true
    $0.titleLabel?.font = .sdGhothicNeo(ofSize: 18, weight: .bold)

  }
  private var first = false

  override func viewDidLoad() {
    setUpCollectionView()
    hideNaviController()
    super.viewDidLoad()
    setUpMainView()
    
  }
  override func setupLayout() {
    self.view.backgroundColor = .white
    self.view.adds([collectionView,
                    skipBtn,
                    pageController,
                    startBtn])
    collectionView.snp.makeConstraints{
      $0.width.equalTo(self.view.safeAreaLayoutGuide)
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
    }
    pageController.snp.makeConstraints{
      $0.top.equalTo(collectionView.snp.bottom)
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(8)
    }
    skipBtn.snp.makeConstraints{
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(26)
      $0.width.equalTo(110)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-89)
      $0.top.equalTo(pageController.snp.bottom).offset(36)
    }
    startBtn.snp.makeConstraints{
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(0)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  func setUpMainView() {
    //제목, 이미지이름
    let boards : [(String,String)] = [("개인 용기 사용을 결심한 당신,\n어떤 용기를 들고 갈지 고민되나요?", "onboarding1"),
                                      ("사람들이 낸 용기와 가게를\n 가볍게 둘러보세요", "onboarding2"),
                                      ("당신의 용기와 느낀점을\n사진과 함께 기록하세요!", "onboarding3"),
                                      ("용기를 낸 보상으로 배지를 드려요!\n", "onboarding4"),
                                      ("용용이와 함께 용기내러 가볼까요?\n", "onboarding5")]
    //비동기일 필요는 없지만,, 델리게이트 쓰기 귀찮아서,,
    Observable.just(boards)
      .bind(to: collectionView.rx.items(cellIdentifier: boardCollectionViewCell.identifier,
                                        cellType: boardCollectionViewCell.self)) {row, data, cell in
        cell.layout()
        cell.infoLabel.text = data.0
        cell.infoImage.image = UIImage(named: data.1)
      }.disposed(by: disposeBag)
    collectionView.rx.didScroll.asObservable()
      .bind{ [weak self] in
        let page = (self?.collectionView.contentOffset.x ?? 0) / UIScreen.main.bounds.width
        self?.showBtnWithAnimation(trigger: Int(page) == 4)
        self?.pageController.currentPage = Int(page)
      }.disposed(by: disposeBag)
    skipBtn.rx.tap.bind{ [weak self] in
      self?.skip()
    }.disposed(by: disposeBag)
    startBtn.rx.tap.bind{ [weak self] in
      let vm = LogInViewModel()
      self?.navigator.show(segue: .onboarding(viewModel: vm), sender: self, transition: .navigation(.right))
    }.disposed(by: disposeBag)
  }
  
}
extension OnboradingViewController {
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.minimumLineSpacing = 0
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    collectionView.register(boardCollectionViewCell.self, forCellWithReuseIdentifier: boardCollectionViewCell.identifier)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.bounces = false
  }
  private func showBtnWithAnimation(trigger: Bool) {
    skipBtn.isHidden = trigger
    if trigger {
      self.startBtn.snp.updateConstraints{
        $0.height.equalTo(88)
      }
      self.startBtn.isHidden = false 
      UIView.animate(withDuration: 0.7,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
                      self.view.layoutIfNeeded()
                     }, completion: {_ in
                      self.startBtn.setTitleColor(.white, for: .normal)
                     })
      first = true
    }
    else if first{
      self.startBtn.snp.updateConstraints{
        $0.height.equalTo(0)
      }
      self.startBtn.titleLabel?.isHidden = true
      UIView.animate(withDuration: 0.7,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
                      self.view.layoutIfNeeded()
                     }, completion: { _ in
                      self.startBtn.isHidden = true
                     })
      first = false
     
    }
    
  }
  private func skip() {
    self.collectionView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 4, y: 0), animated: true)
    //self.showBtnWithAnimation(trigger: true)
  }
}

class boardCollectionViewCell: UICollectionViewCell {
  var infoLabel = UILabel().then{
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 24, weight: .regular)
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  var infoImage = UIImageView()
  
  func layout() {
    self.contentView.adds([infoLabel, infoImage])
    infoLabel.snp.makeConstraints{
      $0.top.equalToSuperview().offset(76)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(76)
    }
    infoImage.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(infoLabel.snp.bottom).offset(52)
      $0.width.height.equalTo(UIScreen.main.bounds.width)
      $0.bottom.equalToSuperview()
    }
  }
}
