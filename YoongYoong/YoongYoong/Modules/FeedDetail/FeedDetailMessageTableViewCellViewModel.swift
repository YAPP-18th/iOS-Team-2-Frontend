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
  
  let feedMessage: CommentResponse
  init(with feedMessage: CommentResponse) {
    self.feedMessage = feedMessage
    super.init()
    profileImageURL.accept(feedMessage.user.imageUrl)
    nickname.accept(feedMessage.user.nickname)
    date.accept(feedMessage.createdDate)
    message.accept(feedMessage.content)
  }
}


