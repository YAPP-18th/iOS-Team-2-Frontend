//
//  TipDetailFirstView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/07.
//

import UIKit

class TipDetailFirstView: UIView {
  let topIndicatorView = UIView().then {
    $0.layer.cornerRadius = 2.5
    $0.layer.masksToBounds = true
  }
  
  let labelContainer = UIView()
  
  let titleLabel = UILabel().then {
    $0.text = "용기 사이즈 정보"
    $0.textColor = .systemGrayText01
    $0.font = .krTitle1
  }
  
  let subtitleLabel = UILabel().then {
    $0.text = """
    *용기별 크기에 맞는 대표적인 음식, 식재료를
    추천했으나 가게별로 상이할 수 있으니 반드시
    용기 선택 전 포스트를 통해 용기 크기를 확인하세요!
    """
    $0.numberOfLines = 0
    $0.font = .krBody3
    $0.textColor = .systemGrayText02
  }
  
  let vStackView = ScrollStackView().then {
    $0.stackView.spacing = 56
    $0.backgroundColor = .clear
    $0.stackView.backgroundColor = .clear
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration()
    setupView()
    setupLayout()
    updateView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if isDarkMode {
      topIndicatorView.backgroundColor = .systemGray03
    } else {
      topIndicatorView.backgroundColor = .systemGray05
    }
  }
  
}

extension TipDetailFirstView {
  private func configuration() {
    if isDarkMode {
      topIndicatorView.backgroundColor = .systemGray03
    } else {
      topIndicatorView.backgroundColor = .systemGray05
    }
  }
  
  private func setupView() {
    [topIndicatorView, vStackView].forEach {
      self.addSubview($0)
    }
    
    [titleLabel, subtitleLabel].forEach {
      labelContainer.addSubview($0)
    }
    vStackView.addArrangedSubview(labelContainer)
  }
  
  
  private func setupLayout() {
    topIndicatorView.snp.makeConstraints {
      $0.top.equalTo(14)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(58)
      $0.height.equalTo(5)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(14)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(22)
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.leading.equalTo(32)
      $0.trailing.equalTo(-32)
      $0.bottom.equalTo(-6)
    }
    
    vStackView.snp.makeConstraints {
      $0.top.equalTo(topIndicatorView.snp.bottom).offset(14)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func updateView() {
    let viewModelList: [TipDetailFirstListView.VIewModel] = [
      .init(
        icon: UIImage(named: "icTipFirstListOne")!,
        title: "밀폐용기",
        itemList: [
          (size: "S", content: TitleContentItem(title: "1.2L 이하", content: "1인분 기준: 김밥, 떡볶이, 샐러드, 반찬, 삼겹살 500g")),
          (size: "M", content: TitleContentItem(title: "1.2L~2.3L", content: "1인분 기준: 냉면, 칼국수, 삼계탕, 찜닭, 생선")),
          (size: "L", content: TitleContentItem(title: "2.3L 초과", content: "기본 2-3인분 요리: 감자탕, 아구찜, 해물찜"))
        ]
      ),
      .init(
        icon: UIImage(named: "icTipFirstListOne")!,
        title: "밀폐용기",
        itemList: [
          (size: "S", content: TitleContentItem(title: "1.2L 이하", content: "1인분 기준: 김밥, 떡볶이, 샐러드, 반찬, 삼겹살 500g")),
          (size: "M", content: TitleContentItem(title: "1.2L~2.3L", content: "1인분 기준: 냉면, 칼국수, 삼계탕, 찜닭, 생선")),
          (size: "L", content: TitleContentItem(title: "2.3L 초과", content: "기본 2-3인분 요리: 감자탕, 아구찜, 해물찜"))
        ]
      ),
      .init(
        icon: UIImage(named: "icTipFirstListOne")!,
        title: "밀폐용기",
        itemList: [
          (size: "S", content: TitleContentItem(title: "1.2L 이하", content: "1인분 기준: 김밥, 떡볶이, 샐러드, 반찬, 삼겹살 500g")),
          (size: "M", content: TitleContentItem(title: "1.2L~2.3L", content: "1인분 기준: 냉면, 칼국수, 삼계탕, 찜닭, 생선")),
          (size: "L", content: TitleContentItem(title: "2.3L 초과", content: "기본 2-3인분 요리: 감자탕, 아구찜, 해물찜"))
        ]
      ),
    ]
    
    viewModelList.forEach {
      let view = TipDetailFirstListView()
      view.viewModel = $0
      self.vStackView.addArrangedSubview(view)
    }
  }
}

