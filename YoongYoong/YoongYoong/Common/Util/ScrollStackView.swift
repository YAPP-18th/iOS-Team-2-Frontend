//
//  ScrollStackView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/07.
//

import UIKit

class ScrollStackView: UIScrollView {
  var containerView = UIView()
  let stackView: UIStackView = {
    let sv = UIStackView()
    sv.alignment = .fill
    sv.distribution = .fill
    sv.axis = .vertical
    sv.spacing = 0
    return sv
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }

  func addArrangedSubview(_ view: UIView) {
    self.stackView.addArrangedSubview(view)
  }

  private func setupUI() {
    contentInsetAdjustmentBehavior = .always

    addSubview(containerView)
    containerView.addSubview(stackView)
    containerView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.width.equalToSuperview()
    }
    stackView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
  }
}
