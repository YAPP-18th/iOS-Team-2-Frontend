//
//  FeedViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import Foundation
import RxCocoa
import RxSwift

class FeedViewModel: ViewModel, ViewModelType {
  struct Input {
    
  }
  
  struct Output {
    let items: BehaviorRelay<[FeedListSection]>
    let profile: Driver<FeedProfileViewModel>
  }
  
  let feedElements = BehaviorRelay<[Feed]>(value: Feed.dummyList)
  let profileSelection = PublishSubject<Void>()
  
  func transform(input: Input) -> Output {
    let elements = BehaviorRelay<[FeedListSection]>(value: [])
    
    feedElements.map { feedList -> [FeedListSection] in
      var elements: [FeedListSection] = []
      let cellViewModel = feedList.map { feed -> FeedListSection.Item in
        FeedListTableViewCellViewModel.init(with: feed)
      }
      elements.append(FeedListSection(items: cellViewModel))
      return elements
    }.bind(to: elements).disposed(by: disposeBag)
    
    let profile = profileSelection.asDriver(onErrorJustReturn: ())
      .map({ (user) -> FeedProfileViewModel in
          let viewModel = FeedProfileViewModel()
          return viewModel
      })
    return Output(
      items: elements,
      profile: profile
    )
  }
}
