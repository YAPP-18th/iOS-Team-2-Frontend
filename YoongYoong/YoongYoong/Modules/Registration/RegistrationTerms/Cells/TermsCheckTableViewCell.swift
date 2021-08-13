//
//  TermsCheckTableViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/05.
//

import UIKit
import RxSwift

class TermsCheckTableViewCell: UITableViewCell {
  let disposeBag = DisposeBag()
  
  let checkButton = UIButton(type: .custom).then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
    $0.setImage(UIImage(named: "icRegChecked"), for: .selected)
    $0.adjustsImageWhenHighlighted = false
  }
  
  let checkLabel = UILabel().then {
    $0.font = .krCaption2
    $0.textColor = .systemGrayText01
  }
  
  let detailButton = UIButton().then {
    let attributedString = NSMutableAttributedString().underlined("자세히", font: .krBody3, color: .systemGrayText01)
    $0.setAttributedTitle(attributedString, for: .normal)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    configuration()
    setupView()
    setupLayout()
  }
}

extension TermsCheckTableViewCell {
  private func configuration() {
    self.selectionStyle = .none
  }
  
  private func setupView() {
    [checkButton, checkLabel, detailButton].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    checkButton.snp.makeConstraints {
      $0.leading.equalTo(24)
      $0.top.bottom.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    checkLabel.snp.makeConstraints {
      $0.leading.equalTo(checkButton.snp.trailing).offset(11)
      $0.centerY.equalTo(checkButton)
      $0.trailing.equalTo(detailButton.snp.leading).offset(-19)
    }
    
    detailButton.snp.makeConstraints {
      $0.trailing.equalTo(-37)
      $0.centerY.equalTo(checkLabel)
      $0.width.equalTo(43)
      $0.height.equalTo(34)
    }
  }
  
  func bind(to viewModel: TermsCheckTableViewCellViewModel) {
    viewModel.title.bind(to: self.checkLabel.rx.text).disposed(by: disposeBag)
    viewModel.selected.bind(to: checkButton.rx.isSelected).disposed(by: disposeBag)
  }
}
