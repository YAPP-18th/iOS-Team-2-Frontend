//
//  FeedDetailMessageTableViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit

class FeedDetailMessageTableViewCell: UITableViewCell {
  struct ViewModel {
    let profileImage: String?
    let name: String?
    let message: String?
    let date: String?
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  
  var height: CGFloat = 0.0
  
  let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = .lightGray
    $0.isUserInteractionEnabled = true
  }
  
  let nameLabel = UILabel().then {
    $0.text = "김용기"
    $0.font = .krTitle2
    $0.textColor = .systemGrayText01
    $0.textAlignment = .left
  }
  
  let messageLabel = UILabel().then {
    $0.text = "용기 낸 사람 멋져요~ 동탄 센트럴파크 맛집 김밥천국 맛있어요! "
    $0.font = .krBody3
    $0.textColor = .systemGrayText01
    $0.numberOfLines = 0
  }
  
  let dateLabel = UILabel().then {
    $0.text = "21.04.24"
    $0.font = .krCaption2
    $0.textColor = .systemGrayText02
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configuration()
    setupView()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func getHeight(viewModel: ViewModel) -> CGFloat {
    let messageLabel = UILabel()
    messageLabel.font = .krBody3
    messageLabel.textColor = .systemGrayText01
    messageLabel.numberOfLines = 0
    messageLabel.text = viewModel.message
    let width = UIScreen.main.bounds.width - 32
    
    
    var height: CGFloat = 0
    let profileHeight: CGFloat = 40.0
    let messageHeight = messageLabel.sizeThatFits(.init(width: width, height: 0)).height
    let dateHeight: CGFloat = 34.0
    
    height = profileHeight + messageHeight + dateHeight
    return height
  }
}
extension FeedDetailMessageTableViewCell {
  private func configuration() {
    contentView.backgroundColor = .white
    selectionStyle = .none
  }
  
  private func setupView() {
    [profileImageView, nameLabel, messageLabel, dateLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  private func setupLayout() {
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(8)
      $0.leading.equalTo(16)
      $0.width.height.equalTo(24)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.centerY.equalTo(profileImageView)
      $0.height.equalTo(20)
    }
    
    messageLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(8)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(messageLabel.snp.bottom)
      $0.leading.equalTo(16)
      $0.bottom.equalTo(-16)
      $0.height.equalTo(18)
    }
  }
  
  private func updateView() {
    guard let vm = self.viewModel else { return }
    nameLabel.text = vm.name
    messageLabel.text = vm.message
    dateLabel.text = vm.date
  }
}
