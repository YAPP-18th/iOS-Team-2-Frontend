//
//  FeedListTableViewCellViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import Foundation
import RxSwift
import RxCocoa

class FeedListTableViewCellViewModel: NSObject {
  let profileImageURL = BehaviorRelay<String?>(value: nil)
  let nickname = BehaviorRelay<String?>(value: nil)
  let storeName = BehaviorRelay<String?>(value: nil)
  let date = BehaviorRelay<String?>(value: nil)
  let contentImageURL = BehaviorRelay<String?>(value: nil)
  let containerList = BehaviorRelay<[TitleContentItem]?>(value: nil)
  
  let feed: Feed
  init(with feed: Feed) {
    self.feed = feed
    super.init()
    profileImageURL.accept(feed.profileImageURL)
    nickname.accept(feed.nickname)
    storeName.accept(feed.storeName)
    date.accept(feed.date)
    contentImageURL.accept(feed.contentImageURL)
    containerList.accept(feed.menuList)
  }
}


