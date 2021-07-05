//
//  TermsCheckSection.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/05.
//

import Foundation
import RxDataSources

struct TermsCheckSection {
  var items: [Item]
}

extension TermsCheckSection: SectionModelType {
  typealias Item = TermsCheckTableViewCellViewModel
  
  init(original: TermsCheckSection, items: [TermsCheckTableViewCellViewModel]) {
    self = original
    self.items = items
  }
}

