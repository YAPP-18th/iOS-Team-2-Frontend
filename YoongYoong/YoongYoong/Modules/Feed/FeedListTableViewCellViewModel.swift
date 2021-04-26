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
  let profileImage = BehaviorRelay<UIImage?>(value: nil)
  let name = BehaviorRelay<String?>(value: nil)
  let storeName = BehaviorRelay<String?>(value: nil)
  let date = BehaviorRelay<String?>(value: nil)
  let contentImage = BehaviorRelay<UIImage?>(value: nil)
  let containerList = BehaviorRelay<[FeedListContainerListViewModel]>(value: [])
}
