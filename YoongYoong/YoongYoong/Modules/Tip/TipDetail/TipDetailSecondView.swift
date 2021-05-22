//
//  TipDetailSecondView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/08.
//


import UIKit

class TipDetailSecondView: UIView {
  let topIndicatorView = UIView().then {
    $0.layer.cornerRadius = 2.5
    $0.layer.masksToBounds = true
  }
  
  let labelContainer = UIView()
  
  let titleLabel = UILabel().then {
    $0.text = "다회용기 실천 가이드"
    $0.textColor = .systemGrayText01
    $0.font = .krTitle1
  }
  
  let vStackView = ScrollStackView().then {
    $0.stackView.spacing = 49
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

extension TipDetailSecondView {
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
    
    labelContainer.addSubview(titleLabel)
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
      $0.top.equalTo(28)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(22)
      $0.bottom.equalTo(-10)
    }
    vStackView.snp.makeConstraints {
      $0.top.equalTo(topIndicatorView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func updateView() {
    let viewModelList: [TipDetailSecondListView.VIewModel] = [
      .init(
        icon: UIImage(named: "icTipSecondListOne")!,
        content: """
        가지고 있는 개인용기 중 주로 사용할 용기를
        자주 쓰는 용기에 등록하세요
        """
      ),
      .init(
        icon: UIImage(named: "icTipSecondListTwo")!,
        content: """
        지도에서 가게를 검색하고 사용할 용기를 결정해요.
        포스트를 보며 용기의 유형과 사이즈를 가늠해봐요
        만약 아직 포스트가 없는 가게라면
        ‘용기별 추천’에서 힌트를 얻으세요!
        """
      ),
      .init(
        icon: UIImage(named: "icTipSecondListThree")!,
        content: """
        결정한 용기를 들고 가게로 이동해요.
        (tip: 배달 어플 사용 시, 요청사항에 개인용기 사용을
        이야기하고 예상 픽업시간 10분전에 도착하세요)
        """
      ),
      .init(
        icon: UIImage(named: "icTipSecondListFour")!,
        content: """
        용기가 여러 개라면 어떤 용기에 어떤 것을
        담아야하는지 가게에 꼭 미리 설명하세요
        (tip: 반찬이나 소스는 이미 일회용기에 포장된 경우가
        많아요. 모든 걸 개인용기에 담기를 강요하지 마세요)
        """
      ),
      .init(
        icon: UIImage(named: "icTipSecondListFive")!,
        content: """
        용기 속 내용물이 흔들리지 않게
        에코백에 넣어오면 좋아요
        """
      ),
    ]
    
    viewModelList.forEach {
      let view = TipDetailSecondListView()
      view.viewModel = $0
      self.vStackView.addArrangedSubview(view)
    }
    
    self.vStackView.addArrangedSubview(UIView())
  }
}


