//
//  ProfilePostCollectionViewCellViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/02.
//

import Foundation
import RxSwift
import RxCocoa

class ProfilePostCollectionViewCellViewModel: NSObject {
  let contentImageURL = BehaviorRelay<String?>(value: nil)
  
  let feed: PostResponse
  init(with feed: PostResponse) {
    self.feed = feed
    super.init()
    contentImageURL.accept(feed.images.first)
  }
}


