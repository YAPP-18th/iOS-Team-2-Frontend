//
//  FeedDetailMessageSection.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit
import RxDataSources

struct FeedDetailMessageSection {
  var items: [Item]
}

extension FeedDetailMessageSection: SectionModelType {
  typealias Item = FeedDetailMessageTableViewCellViewModel
  
  init(original: FeedDetailMessageSection, items: [FeedDetailMessageTableViewCellViewModel]) {
    self = original
    self.items = items
  }
}
