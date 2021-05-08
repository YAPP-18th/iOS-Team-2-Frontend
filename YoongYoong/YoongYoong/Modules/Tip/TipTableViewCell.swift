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
  
  let containerView = UIView()
  
  let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "icTipSecond")
  }
  
  let titleLabel = UILabel().then {
    $0.text = "다회용기 실천 가이드"
    $0.textColor = .systemGray00
    $0.font = .krTitle1
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
  
  func bind(to viewModel: TipTableViewCellViewModel) {
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
    self.contentView.addSubview(containerView)
    [titleLabel, subTitleLabel, iconImageView].forEach {
      containerView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    
    containerView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(30)
      $0.trailing.equalTo(-31)
    }
    
    iconImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.width.height.equalTo(92)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.leading.equalTo(iconImageView.snp.trailing).offset(9)
      $0.trailing.equalTo(-3)
    }
    
    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(9)
      $0.leading.equalTo(iconImageView.snp.trailing).offset(9)
      $0.trailing.equalTo(-3)
    }
    
  }
}
