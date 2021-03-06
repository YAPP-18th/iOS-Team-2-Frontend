//
//  FeedContentImageCollectionViewCell.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/29.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class FeedContentCollectionViewCellViewModel: NSObject, IdentifiableType {
  var identity: String {
    return imageURL.value ?? ""
  }
  var imageURL = BehaviorRelay<String?>(value: nil)
  
  init(imageURL: String) {
    super.init()
    self.imageURL.accept(imageURL)
  }
}

class FeedContentCollectionViewCell: UICollectionViewCell {
  var disposeBag = DisposeBag()
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
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
  
  func bind(to viewModel: FeedContentCollectionViewCellViewModel) {
    viewModel.imageURL.subscribe(onNext: { imageURL in
      guard let imageURL = imageURL else { return }
      ImageDownloadManager.shared.downloadImage(url: imageURL).bind(to: self.imageView.rx.image).disposed(by: self.disposeBag)
    }).disposed(by: self.disposeBag)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
  }
}
extension FeedContentCollectionViewCell {
  private func configuration() {
    
  }
  
  private func setupView() {
    contentView.addSubview(imageView)
  }
  
  private func setupLayout() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
