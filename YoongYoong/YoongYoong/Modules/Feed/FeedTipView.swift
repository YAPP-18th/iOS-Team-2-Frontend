//
//  FeedTipView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/21.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class FeedTipView: UIView {
  private let bag = DisposeBag()
  
  let yongyongImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "imgYongYongTip")
  }
  
  let dateLabel = UILabel().then {
    $0.text = "21.04.24 Sat"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .labelPrimary
  }
  
  let tipLabel = UILabel().then {
    $0.text = "오늘은 냄비로 용기를 내봐용!"
    $0.font = .sdGhothicNeo(ofSize: 16, weight: .bold)
    $0.numberOfLines = 0
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(to viewModel: FeedTipViewModel) {
    viewModel.date.asDriver().drive(self.dateLabel.rx.text).disposed(by: bag)
    viewModel.tip.asDriver().drive(self.tipLabel.rx.text).disposed(by: bag)
  }
}

extension FeedTipView {
  private func configuration() {
     backgroundColor = .white
  }
  
  private func setupView() {
    [yongyongImageView, dateLabel, tipLabel].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupLayout() {
    yongyongImageView.snp.makeConstraints {
      $0.top.equalTo(12)
      $0.leading.equalTo(20)
      $0.width.equalTo(28)
      $0.height.equalTo(42)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(10)
      $0.leading.equalTo(yongyongImageView.snp.trailing).offset(16)
      $0.height.equalTo(16)
    }
    
    tipLabel.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(4)
      $0.leading.equalTo(yongyongImageView.snp.trailing).offset(16)
      $0.trailing.equalTo(-20)
      $0.bottom.equalTo(-14)
      $0.height.greaterThanOrEqualTo(20)
    }
  }
}
