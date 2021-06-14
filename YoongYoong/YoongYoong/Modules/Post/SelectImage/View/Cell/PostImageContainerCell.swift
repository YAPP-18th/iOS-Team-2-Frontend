//
//  PostImageContainerCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/23.
//

import UIKit
import Photos
import RxSwift

class PostImageContainerCell: UICollectionViewCell {
  
  static let reuseIdentifier = String(describing: PostImageContainerCell.self)
  static let cellSize = CGSize(width: 60, height: 60)
  private var imageRequestID: PHImageRequestID?

  
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  let removeButton = UIButton().then {
    $0.contentMode = .scaleToFill
  }
  var didDelete: () -> () = {}
  var deleteDidTap = PublishSubject<Void>()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
    configuration()
  }
  
  func bind() {
    let deleting = PublishSubject<Void>()
    didDelete = { deleting.onNext(()) }
    deleteDidTap = deleting
  }
  

  func setImage(_ asset: PHAsset) {
    let options = PHImageRequestOptions()
    options.isNetworkAccessAllowed = true
    options.isSynchronous = true
    imageRequestID = PHImageManager.default().requestImage(for: asset,
                                                           targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                                           contentMode: .aspectFit, options: options) { image, _ in
      self.imageView.image = image
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()

    if let imageRequestID = imageRequestID {
      PHImageManager.default().cancelImageRequest(imageRequestID)
      self.imageView.image = nil
    }
    
  }
  
  
  private func setupView() {
    contentView.adds([imageView, removeButton])
  }
  
  private func setupLayout() {
    imageView.snp.makeConstraints {
      $0.left.equalTo(contentView).offset(2)
      $0.bottom.equalTo(contentView).offset(-2)
      $0.width.height.equalTo(45)
    }
    
    removeButton.snp.makeConstraints {
      $0.width.height.equalTo(28)
      $0.right.equalTo(contentView)
      $0.top.equalTo(contentView)
    }
  }
  
  private func configuration() {
    removeButton.do {
      $0.setImage(UIImage(named: "Input-Delete_16px_filled"), for: .normal)
      $0.addTarget(self, action: #selector(removeButtonDidTap), for: .touchUpInside)
    }
  }

  @objc
  private func removeButtonDidTap() {
    didDelete()
  }
  

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
