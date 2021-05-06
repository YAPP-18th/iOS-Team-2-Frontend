//
//  TipTableViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/05.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class TipTableViewCell: UITableViewCell {
  let bag = DisposeBag()
  
  let shadowContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "icTipSecond")
  }
  
  let titleLabel = UILabel().then {
    $0.text = "다회용기 실천 가이드"
    $0.textColor = .systemGrayText01
    $0.font = .sdGhothicNeo(ofSize: 24, weight: .bold)
  }
  
  let subTitleLabel = UILabel().then {
    $0.text = "용기내용과 함께하는 다회용기 실천 방법은?"
    $0.textColor = .systemGrayText01
    $0.font = .krBody3
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    shadowContainerView.layer.cornerRadius = 16
    shadowContainerView.layer.applySketchShadow(color: .systemGray01, alpha: 0.2, x: 0, y: 2, blur: 10, spread: 0)
    
    backgroundImageView.layer.cornerRadius = 16
    backgroundImageView.layer.masksToBounds = true
  }
  
  func bind(to viewModel: TipTableViewCellViewModel) {
    viewModel.backgroundImage.asDriver().drive(self.backgroundImageView.rx.image).disposed(by: bag)
    viewModel.iconImage.asDriver().drive(self.iconImageView.rx.image).disposed(by: bag)
    viewModel.title.asDriver().drive(self.titleLabel.rx.text).disposed(by: bag)
    viewModel.subtitle.asDriver().drive(self.subTitleLabel.rx.text).disposed(by: bag)
  }
}

extension TipTableViewCell {
  private func configuration() {
    self.backgroundColor = .clear
    self.contentView.backgroundColor = .clear
    self.selectionStyle = .none
  }
  
  private func setupView() {
    self.contentView.addSubview(shadowContainerView)
    shadowContainerView.addSubview(backgroundImageView)
    [titleLabel, subTitleLabel, iconImageView].forEach {
      backgroundImageView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    shadowContainerView.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-17)
      $0.top.equalTo(12)
      $0.bottom.equalTo(-12)
    }
    
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    iconImageView.snp.makeConstraints {
      $0.trailing.equalTo(-20)
      $0.bottom.equalTo(-16)
    }
    
    subTitleLabel.snp.makeConstraints {
      $0.leading.equalTo(12)
      $0.bottom.equalTo(-16)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(12)
      $0.bottom.equalTo(subTitleLabel.snp.top)
    }
  }
}
