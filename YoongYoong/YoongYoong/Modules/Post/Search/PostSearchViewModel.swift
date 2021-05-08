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
  var dummyData = ["검색어1", "검색어2","검색어3","검색어4", "검색어5"]
 
  struct Input {
    //  searchText, searchHistoryItemDidTap, removeSearchHistoryItem, removeAllButtonDidTap, searchResultItemDidTap
    let searchHistoryItemDidTap: Observable<IndexPath>
    let searchResultItemDidTap: Observable<IndexPath>
    let removeAllButtonDidTap: Observable<Void>
  }
  
  struct Output {
    // searchHistory, searchResult, postMapView
    var searchHistory: Observable<[String]>
    var searchResult: Observable<[Int]>
    var postMapView: Observable<PostMapViewModel>
  }
  
  func transform(input: Input) -> Output {
    
    let postMapViewModel = input.searchResultItemDidTap
      .map { _ in return PostMapViewModel()}
    
    let output = Output(searchHistory: Observable.of(dummyData),
                        searchResult: Observable.of([1,2,3,4,5]),
                        postMapView: postMapViewModel)
    return output
  }
  
}
