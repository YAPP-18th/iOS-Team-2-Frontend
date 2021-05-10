//
//  TipDetailThirdView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/08.
//

import UIKit

class TipDetailThirdView: UIView {
  let topIndicatorView = UIView().then {
    $0.backgroundColor = .systemGray05
    $0.layer.cornerRadius = 2.5
    $0.layer.masksToBounds = true
  }
  
  let labelContainer = UIView()
  
  let titleLabel = UILabel().then {
    $0.text = "개인 용기 이용 꿀팁"
    $0.textColor = .systemGray00
    $0.font = .krTitle1
  }
  
  let vStackView = ScrollStackView()
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
  
  
}

extension TipDetailThirdView {
  private func configuration() {
    self.backgroundColor = .white
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
      $0.top.equalTo(14)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(22)
      $0.bottom.equalTo(-79)
    }
    vStackView.snp.makeConstraints {
      $0.top.equalTo(topIndicatorView.snp.bottom).offset(14)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func updateView() {
    let viewModelList: [TipDetailThirdListView.VIewModel] = [
      .init(
        number: UIImage(named: "icTipThirdListNumOne")!,
        icon: UIImage(named: "icTipThirdListOne")!,
        content: """
        기본 반찬 및 추가 소스를 위한 작은 통이나
        섹션이 구분된 통을 구비해두면 좋아요
        """
      ),
      .init(
        number: UIImage(named: "icTipThirdListNumTwo")!,
        icon: UIImage(named: "icTipThirdListTwo")!,
        content: """
        케이크/타르트 등 디저트 종류는 뒤집어서
        포장해보세요. 뚜껑에 디저트를 얹고 용기를
        거꾸로 덮으면 모양이 망가지지 않아요
        """
      ),
      .init(
        number: UIImage(named: "icTipThirdListNumThree")!,
        icon: UIImage(named: "icTipThirdListThree")!,
        content: """
        기름기가 많은 음식은 유선지를 미리 깔아두세요
        """
      ),
      .init(
        number: UIImage(named: "icTipThirdListNumFour")!,
        icon: UIImage(named: "icTipThirdListFour")!,
        content: """
        개인용기와 함께 에코백을 들고다니면 이동이 더 수월해요
        """
      ),
      .init(
        number: UIImage(named: "icTipThirdListNumFive")!,
        icon: UIImage(named: "icTipThirdListFive")!,
        content: """
        뜨거운 음식은 유리나 스텐인레스에 담고 플라스틱
        밀폐용기의 경우 착색 가능성이 높으니
        색이 진한 음식이나 식재료는 피하면 좋아요
        """
      ),
      
    ]
    
    viewModelList.forEach {
      let view = TipDetailThirdListView()
      view.viewModel = $0
      self.vStackView.addArrangedSubview(view)
      view.snp.makeConstraints {
        $0.height.equalTo(226)
      }
    }
    
    let v = UIView()
    
    self.vStackView.addArrangedSubview(v)
    v.snp.makeConstraints {
      $0.height.equalTo(50)
    }
  }
}
