//
//  FeedListContainerListViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/26.
//

import UIKit
import RxSwift
import RxCocoa

class FeedListContainerListViewModel: NSObject {
  var menuList = BehaviorRelay<[(String, String)]>(value: [])
}
