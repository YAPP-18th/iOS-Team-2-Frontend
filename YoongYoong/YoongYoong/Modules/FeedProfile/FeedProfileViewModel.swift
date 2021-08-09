//
//  FeedProfileViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import Foundation
import RxCocoa
import RxSwift

class FeedProfileViewModel: ViewModel, ViewModelType {
  var userInfo: UserInfo
  private let provider: PostService
  
  init(userInfo: UserInfo, provider: PostService = .init()) {
    self.userInfo = userInfo
    self.provider = provider
    super.init()
  }
  struct Input {
    let badge: Observable<Void>
  }
  
  struct Output {
    let profile: Driver<UserInfo>
    let items: BehaviorRelay<[ProfilePostListSection]>
    let badge: Observable<BadgeListViewModel>
  }
  
  let feedElements = PublishSubject<[PostResponse]>()
  
  func transform(input: Input) -> Output {
    let elements = BehaviorRelay<[ProfilePostListSection]>(value: [])
    
    feedElements.map { feedList -> [ProfilePostListSection] in
      var elements: [ProfilePostListSection] = []
      let cellViewModel = feedList.map { feed -> ProfilePostListSection.Item in
        ProfilePostCollectionViewCellViewModel.init(with: feed)
      }
      elements.append(ProfilePostListSection(items: cellViewModel))
      return elements
    }.bind(to: elements).disposed(by: disposeBag)
    
    self.fetchFeedList()
    
    let badge = input.badge.map { _ -> BadgeListViewModel in
      return .init(user: self.userInfo)
    }
    
    return Output(
      profile: .just(self.userInfo),
      items: elements,
      badge: badge
    )
  }
  
  func fetchFeedList() {
    self.provider.fetchOtherPosts(userId: self.userInfo.id).subscribe(onNext: { result in
      switch result {
      case let .success(list):
        self.feedElements.onNext(list.data ?? [])
      case let .failure(error):
        print(error.localizedDescription)
      }
    }, onError: { (error) in
      print(error.localizedDescription)
    }).disposed(by: self.disposeBag)
  }
}
