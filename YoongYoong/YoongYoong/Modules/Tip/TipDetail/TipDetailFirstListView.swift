//
//  TipDetailFirstListView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/07.
//

import UIKit

class TipDetailFirstListView: UIView {
  struct VIewModel {
    typealias Item = (size: String, content: TitleContentItem)
    let icon: UIImage
    let title: String
    var itemList: [Item]
  }
  
  var viewModel: VIewModel? {
    didSet {
      self.updateView()
    }
  }
  
  var vStackView = UIStackView().then {
    $0.axis = .vertical
  }
  
  let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let titleLabel = UILabel().then {
    $0.textColor = .brandColorGreen01
    $0.font = .krTitle1
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
}

extension TipDetailFirstListView {
  private func configuration() {
    
  }
  
  private func setupView() {
    [iconImageView, titleLabel, vStackView].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupLayout() {
    iconImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(26)
      $0.width.height.equalTo(28)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(iconImageView.snp.trailing).offset(14)
      $0.centerY.equalTo(iconImageView)
    }
    vStackView.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(11)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func updateView() {
    guard let viewModel = self.viewModel else { return }
    self.iconImageView.image = viewModel.icon
    self.titleLabel.text = viewModel.title
    viewModel.itemList.forEach {
      self.vStackView.addArrangedSubview(createListView(item: $0))
    }
  }
  
  private func createListView(item: VIewModel.Item) -> UIView {
    let containerView = UIView()
    let sizeLabel = UILabel().then {
      $0.text = item.size
      $0.textColor = .brandColorGreen01
      $0.font = .sdGhothicNeo(ofSize: 20, weight: .bold)
    }
    
    let rangeLabel = UILabel().then {
      $0.text = item.content.title
      $0.textColor = .systemGrayText01
      $0.font = .sdGhothicNeo(ofSize: 16, weight: .regular)
    }
    
    let descLabel = UILabel().then {
      $0.text = item.content.content
      $0.textColor = .systemGrayText02
      $0.font = .krCaption2
    }
    
    [sizeLabel, rangeLabel, descLabel].forEach {
      containerView.addSubview($0)
    }
    
    sizeLabel.snp.makeConstraints {
      $0.leading.equalTo(35)
      $0.centerY.equalToSuperview()
    }
    
    rangeLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(71)
      $0.trailing.equalTo(-35)
      $0.height.equalTo(30)
    }
    descLabel.snp.makeConstraints {
      $0.top.equalTo(rangeLabel.snp.bottom)
      $0.leading.equalTo(71)
      $0.height.equalTo(18)
      $0.trailing.equalTo(-35)
      $0.bottom.equalToSuperview()
    }
    
    return containerView
  }
}
