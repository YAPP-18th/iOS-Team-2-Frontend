//
//  FeedDetailMessageTableViewCellViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class FeedDetailMessageTableViewCellViewModel: NSObject {
  let profileImageURL = BehaviorRelay<String?>(value: nil)
  let nickname = BehaviorRelay<String?>(value: nil)
  let message = BehaviorRelay<String?>(value: nil)
  let date = BehaviorRelay<String?>(value: nil)
  
  let feedMessage: FeedMessage
  init(with feedMessage: FeedMessage) {
    self.feedMessage = feedMessage
    super.init()
    profileImageURL.accept(feedMessage.profileImageURL)
    nickname.accept(feedMessage.nickname)
    date.accept(feedMessage.date)
    message.accept(feedMessage.message)
  }
}


