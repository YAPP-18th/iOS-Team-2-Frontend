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
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    $0.isPagingEnabled = true
    $0.register(boardCollectionViewCell.self, forCellWithReuseIdentifier: boardCollectionViewCell.identifier)
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.bounces = false
  }
  private var skipBtn = UIButton().then{
    $0.setTitle("건너뛰기", for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.setTitleColor(.systemGray02, for: .normal)
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
    hideNaviController()
    super.viewDidLoad()
    setUpMainView()
    
  }
  override func setupLayout() {
    self.view.backgroundColor = .systemGray00
    self.view.adds([collectionView,
                    skipBtn,
                    pageController,
                    startBtn])
    skipBtn.snp.makeConstraints{
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(26)
      $0.width.equalTo(110)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-56)
    }
    
    pageController.snp.makeConstraints{
      $0.bottom.equalTo(skipBtn.snp.top).offset(-19)
      $0.centerX.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalTo(pageController.snp.top)
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
    collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    Observable.just(boards)
      .bind(to: collectionView.rx.items(cellIdentifier: boardCollectionViewCell.identifier,
                                        cellType: boardCollectionViewCell.self)) {row, data, cell in
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
      let vm = LoginViewModel()
      self?.navigator.show(segue: .onboarding(viewModel: vm), sender: self, transition: .navigation(.right))
    }.disposed(by: disposeBag)
  }
  
}
extension OnboradingViewController {
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

extension OnboradingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.frame.size
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

class boardCollectionViewCell: UICollectionViewCell {
  var infoLabel = UILabel().then{
    $0.textColor = .systemGrayText01
    $0.font = .krHeadline
    $0.numberOfLines = 2
    $0.adjustsFontSizeToFitWidth = true
    $0.minimumScaleFactor = 0.5
    $0.textAlignment = .center
  }
  var infoImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func layout() {
    self.contentView.backgroundColor = .systemGray00
    self.contentView.adds([infoLabel, infoImage])
    infoLabel.snp.makeConstraints{
      $0.top.equalToSuperview().offset(76)
      $0.leading.equalTo(37)
      $0.trailing.equalTo(-37)
    }
    infoLabel.setContentHuggingPriority(.required, for: .vertical)
    infoImage.snp.makeConstraints{
      $0.top.equalTo(infoLabel.snp.bottom).offset(32)
      $0.centerX.bottom.equalToSuperview()
    }
  }
}
