//
//  FeedTipViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/26.
//

import UIKit
import RxSwift
import RxCocoa

class FeedTipViewModel: NSObject {
  let date = BehaviorRelay<String?>(value: nil)
  let tip = BehaviorRelay<String?>(value: nil)
}
