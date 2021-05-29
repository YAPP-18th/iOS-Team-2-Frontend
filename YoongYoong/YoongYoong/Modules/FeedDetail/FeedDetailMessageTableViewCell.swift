//
//  FeedDetailMessageTableViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit
import RxSwift
import RxCocoa

class FeedDetailMessageTableViewCell: UITableViewCell {
  let bag = DisposeBag()
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
  
  func bind(to viewModel: FeedDetailMessageTableViewCellViewModel) {
    viewModel.nickname.asDriver().drive(self.nameLabel.rx.text).disposed(by: bag)
    viewModel.message.asDriver().drive(self.messageLabel.rx.text).disposed(by: bag)
    viewModel.date.asDriver().drive(self.dateLabel.rx.text).disposed(by: bag)
    viewModel.profileImageURL.subscribe(onNext: { url in
      guard let url = url else { return }
      ImageDownloadManager.shared.downloadImage(url: url).bind(to: self.profileImageView.rx.image).disposed(by: self.bag)
    }).disposed(by: bag)
    self.height = Self.getHeight(viewModel: viewModel)
  }
  
  static func getHeight(viewModel: FeedDetailMessageTableViewCellViewModel) -> CGFloat {
    let messageLabel = UILabel()
    messageLabel.font = .krBody3
    messageLabel.textColor = .systemGrayText01
    messageLabel.numberOfLines = 0
    messageLabel.text = viewModel.message.value
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
    
  }
}
