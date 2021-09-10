//
//  ProfilePostCollectionViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/02.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ProfilePostCollectionViewCell: UICollectionViewCell {
  private let bag = DisposeBag()
  
  let contentImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
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
    
  }
  
  func bind(to viewModel: ProfilePostCollectionViewCellViewModel) {
    viewModel.contentImageURL.subscribe(onNext: { url in
      guard let url = url else { return }
      ImageDownloadManager.shared.downloadImage(url: url).bind(to: self.contentImageView.rx.image).disposed(by: self.bag)
    }).disposed(by: self.bag)
  }
}

extension ProfilePostCollectionViewCell {
  private func configuration() {
    self.contentView.backgroundColor = .white
  }
  
  private func setupView() {
    self.contentView.addSubview(contentImageView)
  }
  
  private func setupLayout() {
    
    contentImageView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(1)
    }
  }
  
  private func updateView() {
    
  }
}

