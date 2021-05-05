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
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yy.MM.dd EEE"
    return formatter
  }()
  
  let feedElements = BehaviorRelay<[Feed]>(value: Feed.dummyList)
  let profileSelection = PublishSubject<Void>()
  let currentDate = BehaviorRelay<String>(value: "")
  let brave = BehaviorRelay<String>(value: BraveWord.default)
  
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
    
    currentDate.accept(dateFormatter.string(from: Date()))
    let braveWord = BraveWord()
    brave.accept(braveWord.randomBrave() ?? BraveWord.default)
    
    return Output(
      items: elements,
      profile: profile
    )
  }
}
