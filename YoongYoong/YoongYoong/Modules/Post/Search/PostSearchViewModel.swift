//
//  PostSearchViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/20.
//

import Foundation
import RxSwift
import RxCocoa

class PostSearchViewModel: ViewModel, ViewModelType {
  struct Input {
    // textFieldShouldBeginEditing, searchButtonDidTap, searchHistoryItemDidTap, removeButtonDidTap, removeAllButtonDidTap, searchResultItemDidTap
  }
  
  struct Output {
    // fetchSearchHistory, fetchSearchResult, postMapView
  }
  
  func transform(input: Input) -> Output {
    return Output()
  }
  
}
