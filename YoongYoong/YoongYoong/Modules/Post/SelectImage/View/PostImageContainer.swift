//
//  PostImageContainer.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/23.
//

import UIKit

class PostImageContainer: UIView {
  
  var collectionView: UICollectionView!
  
  private func setupView() {
    self.add(collectionView)
    
  }
  
  private func setupLayout() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
  }
  
  private func configuration() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = PostImageContainerCell.cellSize
    layout.minimumInteritemSpacing = 15
    layout.sectionInset = UIEdgeInsets(top: 0,
                                       left: 16,
                                       bottom: 0,
                                       right: 16)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.register(PostImageContainerCell.self,
                            forCellWithReuseIdentifier: PostImageContainerCell.reuseIdentifier)
    collectionView.backgroundColor = .white
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.allowsSelection = true
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
