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
  struct Input {
    
  }
  
  struct Output {
    let items: BehaviorRelay<[ProfilePostListSection]>
  }
  
  let feedElements = BehaviorRelay<[Feed]>(value: Feed.dummyList)
  
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
    return Output(
      items: elements
    )
  }
}
