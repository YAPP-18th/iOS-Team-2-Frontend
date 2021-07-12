//
//  FeedListContainerListView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/21.
//

import UIKit
import Then
import SnapKit

class FeedListContainerListView: UIView {
  struct ViewModel {
    let menus: [PostContainerModel]
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  var stackView = UIStackView().then {
    $0.axis = .vertical
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

extension FeedListContainerListView {
  private func configuration() {
    self.backgroundColor = .systemGray00
  }
  
  private func setupView() {
    addSubview(stackView)
  }
  
  private func setupLayout() {
    stackView.snp.makeConstraints {
      $0.top.equalTo(8)
      $0.leading.equalTo(12)
      $0.bottom.equalTo(-6)
      $0.trailing.equalTo(-12)
    }
  }
  
  private func updateView() {
    guard let vm = self.viewModel else { return }
    
    self.stackView.arrangedSubviews.forEach {
      self.stackView.removeArrangedSubview($0)
      $0.isHidden = true
    }
    let itemList = vm.menus.map { TitleContentItem(title:"\($0.food) \($0.foodCount) \($0.container.name)\($0.container.size) \($0.containerCount)")}
    
    itemList.forEach { item in
      let view = UIView()
      let menuLabel = UILabel().then {
        $0.text = item.title
        $0.font = .krCaption2
        $0.textColor = .systemGrayText01
      }
      
      let containerLabel = UILabel().then {
        $0.text = item.content
        $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
        $0.textColor = .init(hexString: "#828282")
      }
      
      [menuLabel, containerLabel].forEach {
        view.addSubview($0)
      }
      
      menuLabel.snp.makeConstraints {
        $0.leading.centerY.equalToSuperview()
      }
      
      containerLabel.snp.makeConstraints {
        $0.leading.equalTo(menuLabel.snp.trailing).offset(8)
        $0.centerY.equalToSuperview()
      }
      
      view.snp.makeConstraints {
        $0.height.equalTo(18)
      }
      
      self.stackView.addArrangedSubview(view)
      view.isHidden = false
    }
  }
}
