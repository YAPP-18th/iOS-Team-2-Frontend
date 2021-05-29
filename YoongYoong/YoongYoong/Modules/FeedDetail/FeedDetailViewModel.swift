//
//  FeedDetailViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class FeedDetailViewModel : ViewModel, ViewModelType {
  struct Input {
    
  }
  struct Output {
    let items: BehaviorRelay<[FeedDetailMessageSection]>
  }
  
  let feedMessageElements = BehaviorRelay<[FeedMessage]>(value: FeedMessage.dummyList)
  
}
extension FeedDetailViewModel {
  func transform(input: Input) -> Output {
    let elements = BehaviorRelay<[FeedDetailMessageSection]>(value: [])
    
    feedMessageElements.map { feedList -> [FeedDetailMessageSection] in
      var elements: [FeedDetailMessageSection] = []
      let cellViewModel = feedList.map { feed -> FeedDetailMessageSection.Item in
        FeedDetailMessageTableViewCellViewModel.init(with: feed)
      }
      elements.append(FeedDetailMessageSection(items: cellViewModel))
      return elements
    }.bind(to: elements).disposed(by: disposeBag)
    
    return .init(
      items: elements
    )
  }
}
