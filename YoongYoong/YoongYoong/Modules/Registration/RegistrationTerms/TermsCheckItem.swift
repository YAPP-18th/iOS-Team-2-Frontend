//
//  TermsCheckItem.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit
import RxSwift
import RxCocoa

class TermsCheckItemViewModel: NSObject {
  let title = BehaviorRelay<String?>(value: nil)
  let detail = BehaviorRelay<String?>(value: nil)
  
  var check = BehaviorRelay<Bool>(value: false)
  init(title: String, detail: String) {
    super.init()
    self.title.accept(title)
    self.detail.accept(detail)
  }
}

class TermsCheckItem: UIView {
  let disposeBag = DisposeBag()
  
  let checkButton = UIButton(type: .custom).then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
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
  
  // MARK: Object lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    configuration()
    setupView()
    setupLayout()
  }
  
  func bind(to viewModel: TermsCheckItemViewModel) {
    viewModel.title.bind(to: checkLabel.rx.text).disposed(by: self.disposeBag)
    viewModel.check.subscribe(onNext: { isChecked in
      let isCheckedImage = isChecked ? UIImage(named: "icRegChecked") : UIImage(named: "icRegUnchecked")
      self.checkButton.setImage(isCheckedImage, for: .normal)
    }).disposed(by: self.disposeBag)
    self.checkButton.rx.tap.map { !viewModel.check.value }.bind(to: viewModel.check).disposed(by: self.disposeBag)
  }
}

extension TermsCheckItem {
  private func configuration() {
    
  }
  
  private func setupView() {
    [checkButton, checkLabel, detailButton].forEach {
      self.addSubview($0)
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
    }
    
    detailButton.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  private func updateView() {
    
  }
}
