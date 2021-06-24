//
//  MapSearchViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/19.
//

import Foundation
import RxSwift
import RxCocoa

class MapSearchViewModel: ViewModel, ViewModelType {
  struct Input {
    let searchTextFieldDidBeginEditing: Observable<Void>
    let searchButtonDidTap: PublishSubject<String>
    let removeSearchHistoryItem: PublishSubject<Int>
  }
  
  struct Output {
    var searchHistory: BehaviorSubject<[String]>
  }
  
  func transform(input: Input) -> Output {
    let model = PostSearchModel()
    let searchHistory = BehaviorSubject<[String]>(value: model.loadSearchHistory())
    
    input.removeSearchHistoryItem
      .subscribe(onNext: {
        model.remove($0) {searchHistory.onNext($0)}
      }).disposed(by: disposeBag)
    
    return .init(
      searchHistory: searchHistory
    )
  }
}
