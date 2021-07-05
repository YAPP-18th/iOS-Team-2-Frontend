//
//  TermsCheckTableViewCellViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa

class TermsCheckTableViewCellViewModel: NSObject {
  let id = BehaviorRelay<Int>(value: 1)
  let title = BehaviorRelay<String>(value: "")
  let selected = BehaviorRelay<Bool>(value: false)
  let commentButtonDidTap = PublishSubject<PostResponse>()
  
  let item: TermsCheckItem
  init(with item: TermsCheckItem) {
    self.item = item
    super.init()
    id.accept(item.id)
    title.accept(item.title)
    selected.accept(item.selected)
  }
}



