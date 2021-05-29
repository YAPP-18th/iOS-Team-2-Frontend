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
  var menuList = BehaviorRelay<[TitleContentItem]>(value: [])
  
  let menus: [PostContainerModel]
  
  init(with menus: [PostContainerModel]) {
    self.menus = menus
    super.init()
    menuList.accept(menus.map { .init(title: $0.food, content: "\($0.container.name) \($0.container.size)")})
  }
}
