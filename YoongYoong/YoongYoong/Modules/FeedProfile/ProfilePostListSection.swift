//
//  ProfilePostListSection.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/02.
//

import UIKit
import RxDataSources

struct ProfilePostListSection {
  var items: [Item]
}

extension ProfilePostListSection: SectionModelType {
  typealias Item = ProfilePostCollectionViewCellViewModel
  
  init(original: ProfilePostListSection, items: [ProfilePostCollectionViewCellViewModel]) {
    self = original
    self.items = items
  }
}
