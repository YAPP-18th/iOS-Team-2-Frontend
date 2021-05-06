//
//  TipTableViewCellViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/06.
//

import Foundation
import RxSwift
import RxCocoa

class TipTableViewCellViewModel: NSObject {
  let backgroundImage = BehaviorRelay<UIImage?>(value: nil)
  let iconImage = BehaviorRelay<UIImage?>(value: nil)
  let title = BehaviorRelay<String?>(value: nil)
  let subtitle = BehaviorRelay<String?>(value: nil)
  
  let tip: Tip
  init(with tip: Tip) {
    self.tip = tip
    super.init()
    backgroundImage.accept(tip.backgroundImage)
    iconImage.accept(tip.iconImage)
    title.accept(tip.title)
    subtitle.accept(tip.subtitle)
  }
}
