//
//  PostImageSelectionViewCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/23.
//

import UIKit
import SnapKit
import Photos

class PostImageSelectionViewCell: UICollectionViewCell {
  
  static let reuseIdentifier = String(describing: PostImageSelectionViewCell.self)
  static let cellSize =
    CGSize(width: (UIScreen.main.bounds.width-8)/3, height: (UIScreen.main.bounds.width-8)/3)
  private var imageRequestID: PHImageRequestID?

  override var isSelected: Bool {
    didSet {
      self.selectView.isHidden = !isSelected
      self.deselectView.isHidden = isSelected
    }
  }

  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  let cameraImageView = UIImageView().then {
    $0.image = #imageLiteral(resourceName: "Camera-stroked")
  }
  
  let deselectView = UIView().then {
    $0.isOpaque = true
  }
  
  let selectView = UIView().then {
    $0.isOpaque = true
    $0.layer.borderWidth = 3
    $0.layer.borderColor = UIColor.brandColorGreen01.cgColor
    $0.isHidden = true
  }
  

  let selectLabel = UILabel().then {
    $0.backgroundColor = UIColor.brandColorGreen01
    $0.textAlignment = .center
    $0.layer.borderWidth = 2
    $0.layer.borderColor = UIColor.brandColorGreen01.cgColor
    $0.clipsToBounds = true
    $0.textColor = .white
    $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
  }
  
  let deselectLabel = UILabel().then {
    $0.backgroundColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
    $0.alpha = 0.3
    $0.layer.borderWidth = 2
    $0.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    $0.clipsToBounds = true
    $0.font = UIFont.sdGhothicNeo(ofSize: 12, weight: .regular)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
    configuration()
  }
  
  func setNumber(_ num: Int) {
    self.selectLabel.text = "\(num)"
  }
  
  func setCameraView() {
    self.cameraImageView.isHidden = false
    self.imageView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
    self.deselectLabel.isHidden = true
  }
  
  func setImage(_ asset: PHAsset) {
    let options = PHImageRequestOptions()
    options.isNetworkAccessAllowed = true

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
    }
    
    self.imageView.image = nil
    self.imageView.backgroundColor = .white
    self.cameraImageView.isHidden = true
    self.deselectLabel.isHidden = false
    
  }
  
  private func setupView() {
    selectView.add(selectLabel)
    deselectView.add(deselectLabel)
    contentView.adds([imageView, deselectView, selectView, cameraImageView])
  }
  
  private func setupLayout() {
    imageView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
    }
    
 
    selectView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
    }
    
    selectLabel.snp.makeConstraints {
      $0.height.width.equalTo(selectView.snp.width).multipliedBy(0.2)
      $0.right.equalTo(selectView.snp.right).offset(-8)
      $0.top.equalTo(selectView.snp.top).offset(8)
    }
    
    deselectView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
    }
    
    deselectLabel.snp.makeConstraints {
      $0.height.width.equalTo(deselectView.snp.width).multipliedBy(0.2)
      $0.right.equalTo(deselectView.snp.right).offset(-8)
      $0.top.equalTo(deselectView.snp.top).offset(8)
    }
    
    cameraImageView.snp.makeConstraints {
      $0.center.equalTo(contentView)
      $0.width.height.equalTo(30)
    }
    
  }
  
  private func configuration() {
    selectLabel.layer.cornerRadius = contentView.bounds.size.width*0.2*0.5
    deselectLabel.layer.cornerRadius = contentView.bounds.size.width*0.2*0.5
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
