//
//  FeedMessage.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
struct FeedMessage {
  static let dummyList:[FeedMessage] = [
    .init(
      nickname: "김용기",
      profileImageURL: "",
      message: "용기 낸 사람 멋져요~ 동탄 센트럴파크 김밥천국이 맛있던데 한번 용기내러 저도 가봐야겠어요! ",
      date: "2021-04-24"
    ),
    .init(
      nickname: "김용기",
      profileImageURL: "",
      message: "용기 낸 사람 멋져요~ 동탄 센트럴파크 맛집 김밥천국 맛있어요! ",
      date: "2021-04-24"
    ),
    .init(
      nickname: "김용기",
      profileImageURL: "",
      message: "용기 낸 사람 멋져요~ 동탄 센트럴파크 김밥천국이 맛있던데 한번 용기내러 저도 가봐야겠어요! ",
      date: "2021-04-24"
    ),
    .init(
      nickname: "김용기",
      profileImageURL: "",
      message: "용기 낸 사람 멋져요~ 동탄 센트럴파크 맛집 김밥천국 맛있어요! ",
      date: "2021-04-24"
    ),
    .init(
      nickname: "김용기",
      profileImageURL: "",
      message: "용기 낸 사람 멋져요~ 동탄 센트럴파크 김밥천국이 맛있던데 한번 용기내러 저도 가봐야겠어요! ",
      date: "2021-04-24"
    ),
    .init(
      nickname: "김용기",
      profileImageURL: "",
      message: "용기 낸 사람 멋져요~ 동탄 센트럴파크 맛집 김밥천국 맛있어요! ",
      date: "2021-04-24"
    )
  ]
  
  var nickname: String?
  var profileImageURL: String?
  var message: String?
  var date: String?
}
