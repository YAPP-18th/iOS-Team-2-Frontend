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
    let removeAllButtonDidTap: Observable<Void>
    let searchHistoryItemDidTap: Observable<IndexPath>
    let searchResultItemDidTap: Observable<IndexPath>
  }
  
  struct Output {
    var searchHistory: BehaviorSubject<[String]>
    var searchResult: Observable<[Place]>
    var searchError: Observable<String>
    var searchHistorySelected: PublishSubject<String>
    var searchResultView: PublishRelay<MapSearchResultViewModel>
  }
  
  let searchHistorySelected = PublishSubject<String>()
  let searchResult = BehaviorSubject<[Place]>(value: [])
  
  let searchSuccess = PublishSubject<[Place]>()
  let searchError = PublishSubject<String>()
  
  func transform(input: Input) -> Output {
    let model = PostSearchModel()
    let searchHistory = BehaviorSubject<[String]>(value: model.loadSearchHistory())
    
    input.removeSearchHistoryItem
      .subscribe(onNext: {
        model.remove($0) {searchHistory.onNext($0)}
      }).disposed(by: disposeBag)
    
    input.removeAllButtonDidTap
      .subscribe(onNext: {
        model.remove(nil) {searchHistory.onNext($0)}
      }).disposed(by: disposeBag)
    
    input.searchHistoryItemDidTap
      .map {model.searchItem(at: $0.row)}
      .bind(to: input.searchButtonDidTap, searchHistorySelected)
      .disposed(by: disposeBag)
    
    input.searchButtonDidTap
      .filter { $0.count > 0 }
      .subscribe(onNext: {
        model.add($0) {searchHistory.onNext($0)}
      }).disposed(by: disposeBag)
    
    input.searchButtonDidTap.flatMapLatest { [weak self] in
      model.search($0, self?.locationManager.locationChanged.value, nextPage: false)
    }.subscribe(onNext: { result in
      switch result {
      case .success(let places):
        self.searchResult.onNext(places)
        self.searchSuccess.onNext(places)
      case .failure(_):
        self.searchError.onNext("검색 결과를 불러올 수 없음.")
      }
    }).disposed(by: disposeBag)
    
    let mapSearchResultViewModel = PublishRelay<MapSearchResultViewModel>()
    Observable.combineLatest(searchResult, input.searchResultItemDidTap)
      .sample(input.searchResultItemDidTap)
      .map { places, indexPath -> MapSearchResultViewModel in
        let viewModel = MapSearchResultViewModel(place: places[indexPath.row])
        return viewModel
      }.bind(to: mapSearchResultViewModel)
      .disposed(by: disposeBag)
    
    return .init(
      searchHistory: searchHistory,
      searchResult: searchSuccess,
      searchError: searchError,
      searchHistorySelected: searchHistorySelected,
      searchResultView: mapSearchResultViewModel
    )
  }
}
