//
//  MyBadgeSection.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/26.
//

import Foundation
import RxDataSources

struct MyBadgeSection {
  var items: [Item]
}

extension MyBadgeSection: SectionModelType {
  typealias Item = BadgeModel
  init(original: MyBadgeSection, items: [Item]) {
    self = original
    self.items = items
  }
}
