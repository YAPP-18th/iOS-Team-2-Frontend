//
//  TermsCheckItem.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit
import RxSwift
import RxCocoa


class TermsCheckItem: UIView {
  struct ViewModel {
    var id: Int
    var isChecked: Bool
    var title: String
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  
  var checkClosure: (_ checked: Bool) -> Void = { _ in }
  
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
}

extension TermsCheckItem {
  private func configuration() {
    self.checkButton.rx.tap.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      guard let vm = self.viewModel else { return }
      self.viewModel?.isChecked = !vm.isChecked
      self.checkClosure(!vm.isChecked)
    }).disposed(by: disposeBag)
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
    guard let vm = self.viewModel else { return }
    self.checkLabel.text = vm.title
    let checkImage = vm.isChecked ? UIImage(named: "icRegChecked") : UIImage(named: "icRegUnchecked")
    self.checkButton.setImage(checkImage, for: .normal)
  }
}
