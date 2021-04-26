//
//  FeedListSection.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import UIKit
import RxDataSources

struct FeedListSection {
  var header: String
  var items: [Item]
}

extension FeedListSection: SectionModelType {
  typealias Item = FeedListTableViewCellViewModel
  
  init(original: FeedListSection, items: [FeedListTableViewCellViewModel]) {
    self = original
    self.items = items
  }
}
