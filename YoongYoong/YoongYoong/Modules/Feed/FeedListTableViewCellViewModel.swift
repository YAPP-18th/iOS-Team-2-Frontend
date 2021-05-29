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
  let contentImageURL = BehaviorRelay<[String]>(value: [])
  let containerList = BehaviorRelay<[PostContainerModel]>(value: [])
  let likecount = BehaviorRelay<String>(value: "0")
  let messageCount = BehaviorRelay<String>(value: "0")
  
  let userSelection = PublishSubject<UserInfo>()
  
  let feed: PostResponse
  init(with feed: PostResponse) {
    self.feed = feed
    super.init()
    profileImageURL.accept(feed.user.imageUrl)
    nickname.accept(feed.user.nickname)
    storeName.accept(feed.placeName)
    date.accept(feed.createdDate)
    contentImageURL.accept(feed.images)
    containerList.accept(feed.postContainers)
    likecount.accept("\(feed.likeCount)")
    messageCount.accept("\(feed.commentCount)")
  }
}


