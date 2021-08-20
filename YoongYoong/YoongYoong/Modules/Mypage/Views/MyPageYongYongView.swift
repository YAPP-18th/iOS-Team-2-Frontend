//
//  MyPageYongYongView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/26.
//

import UIKit

class MyPageYongYongView: UIView {
  struct ViewModel {
    var image: UIImage?
    var comment: String
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  
  let yongyongImageView = UIImageView().then {
    $0.image = UIImage(named: "yongyong1")
    $0.contentMode = .scaleAspectFit
  }
  
  let commentContainer = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.brandColorGreen01.cgColor
  }
  
  let commentLabel = UILabel().then {
    $0.text = "용기를 내고 배지를 모아보세요!"
    $0.textColor = .systemGrayText01
    $0.font = .krBody3
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.commentContainer.layer.cornerRadius = self.commentContainer.frame.height / 2
  }
  
  private func configuration() {
    self.backgroundColor = .brandColorGreen03
  }
  
  private func setupView() {
    [yongyongImageView, commentContainer].forEach {
      self.addSubview($0)
    }
    
    commentContainer.addSubview(commentLabel)
  }
  
  private func setupLayout() {
    yongyongImageView.snp.makeConstraints {
      $0.leading.equalTo(15)
      $0.top.equalTo(10)
      $0.bottom.equalTo(-10)
    }
    commentContainer.snp.makeConstraints {
      $0.leading.equalTo(yongyongImageView.snp.trailing).offset(18)
      $0.centerY.equalToSuperview()
    }
    
    commentLabel.snp.makeConstraints {
      $0.top.equalTo(7)
      $0.leading.equalTo(8)
      $0.trailing.equalTo(-8)
      $0.bottom.equalTo(-7)
    }
  }
  
  private func updateView() {
    guard let vm = self.viewModel else { return }
    self.yongyongImageView.image = vm.image
    self.commentLabel.text = vm.comment
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }
}
