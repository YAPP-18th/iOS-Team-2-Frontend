//
//  FeedListSection.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import UIKit
import RxDataSources

struct FeedListSection {
  var items: [Item]
}

extension FeedListSection: AnimatableSectionModelType {
  typealias Item = FeedListTableViewCellViewModel
  
  init(original: FeedListSection, items: [FeedListTableViewCellViewModel]) {
    self = original
    self.items = items
  }
  var identity: Int {
    return 0
  }
}


struct FeedContentImageSection {
  var items: [Item]
}

extension FeedContentImageSection: AnimatableSectionModelType {
  typealias Item = FeedContentCollectionViewCellViewModel

  init(original: FeedContentImageSection, items: [FeedContentCollectionViewCellViewModel]) {
    self = original
    self.items = items
  }
  
  var identity: Int {
    return 0
  }
}

