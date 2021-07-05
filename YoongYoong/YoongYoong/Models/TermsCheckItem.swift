//
//  TermsCheckItem.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/05.
//

import Foundation

class TermsCheckItem {
  
  let id: Int
  let title: String
  var selected: Bool
  
  init(id: Int, title: String, selected: Bool) {
    self.id = id
    self.title = title
    self.selected = selected
  }
}
