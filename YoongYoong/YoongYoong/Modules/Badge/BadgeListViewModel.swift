//
//  BadgeListViewModel.swift
//  용기내용
//
//  Created by 손병근 on 2021/07/31.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
final class BadgeListViewModel: ViewModel, ViewModelType {
  
  struct Input {
    
  }
  
  struct Output {
    let user: Observable<UserInfo>
    let badgeList: Driver<[MyBadgeSection]>
  }
  
  let user: UserInfo
  init(user: UserInfo) {
    self.user = user
  }
  
  func transform(input: Input) -> Output {
    let badgeArr: [BadgeModel] = user.id == 0 ? [] : [BadgeModel(badgeId: 0, imagePath: "icBadge001", title: "관심도 용기", discription: "처음으로 다른 사람의 포스트에\n좋아요를 누르면 드려요", condition: "다른 사람 포스트에 첫 좋아요를 누를 시"),
                    BadgeModel(badgeId: 1, imagePath: "icBadge002", title: "첫 용기", discription: "깨끗한 지구를 위한 첫 걸음!\n당신의 용기 덕분이예요", condition: "첫 포스트를 올릴 시 획득"),
                    BadgeModel(badgeId: 2, imagePath: "icBadge003", title: "작심삼일 극복!", discription: "연속 3일이상 포스트를 작성해보세요", condition: "연속 3일 이상 포스트를 올릴 시"),
                    BadgeModel(badgeId: 3, imagePath: "icBadge004", title: "말 건내는 용기", discription: "처음으로 다른 사람의 포스트에 댓글을 달면 드려요", condition: "다른 사람 포스트에 첫 댓글을 달면"),
                    BadgeModel(badgeId: 4, imagePath: "icBadge005", title: "레스웨이스트", discription: "포스트를 10개 이상 올려보세요", condition: "포스트 10개 이상 올릴 시"),
                    BadgeModel(badgeId: 5, imagePath: "icBadge006", title: "이목집중 용기왕", discription: "다른 사람으로부터 좋아요를 총 20개 받아보세요!", condition: "내가 쓴 포스트의 좋아요가 누적 20개 넘을 시"),
                    BadgeModel(badgeId: 6, imagePath: "icBadge007", title: "용기 마당발", discription: "총 30개의 가게에서 용기를 사용하면 드려요", condition: "용기 등록한 가게가 30개 넘을 시"),
                    BadgeModel(badgeId: 7, imagePath: "icBadge008", title: "세계최고 환경 지킴이", discription: "포스트를 100개 이상 올려보세요", condition: "포스트 100개 이상 올릴 시"),
                    BadgeModel(badgeId: 8, imagePath: "icBadge009", title: "용기 매니아", discription: "서로 다른 용기를 3개 이상을 포스트에 등록하세요", condition: "서로 다른 용기 3개 이상 포스트 등록했을 시"),
                    BadgeModel(badgeId: 9, imagePath: "icBadge010", title: "단골 손님", discription: "한 가게에 두 개 이상의 포스트를 작성해보세요", condition: "한 가게에 대해 두 번 이상 포스트를 올릴 시"),
                    BadgeModel(badgeId: 10, imagePath: "icBadge011", title: "제로 웨이스트", discription: "포스트를 10개 이상 올려보세요", condition: "포스트 10개 이상 올릴 시"),
                    BadgeModel(badgeId: 11, imagePath: "icBadge012", title: "용기의 달인", discription: "포스트를 30개 이상 올려보세요", condition: "포스트 30개 이상 올릴 시")
            ]
    
    let badgeList = Observable.of(badgeArr).map { list -> [MyBadgeSection] in
      let section = MyBadgeSection(items: list)
      return [section]
    }.asDriver(onErrorJustReturn: [])
    
    return .init(
      user: .just(self.user),
      badgeList: badgeList
    )
  }
}
