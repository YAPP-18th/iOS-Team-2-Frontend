//
//  TipSection.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/06.
//

import UIKit
import RxDataSources

struct TipSection {
  var items: [Item]
}

extension TipSection: SectionModelType {
  typealias Item = TipTableViewCellViewModel
  
  init(original: TipSection, items: [TipTableViewCellViewModel]) {
    self = original
    self.items = items
  }
}
