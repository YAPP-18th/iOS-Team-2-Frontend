//
//  PostSearchViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/20.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class PostSearchViewModel: ViewModel, ViewModelType {
  struct Input {
    let searchButtonDidTap: PublishSubject<String>
    let resultTableViewReachedBottom: Observable<Bool>
    let removeSearchHistoryItem: PublishSubject<Int>
    let removeAllButtonDidTap: Observable<Void>
    let searchHistoryItemDidTap: Observable<IndexPath>
    let searchResultItemDidTap: Observable<IndexPath>
  }
  
  struct Output {
    var searchHistory: PublishSubject<[String]>
    var searchResult: Observable<[Place]>
    var searchError: Observable<SearchAPIError>
    var postMapView: Observable<PostMapViewModel>
    var searchHistorySelected: PublishSubject<String>
  }
  
  private var isPaging = false
  func transform(input: Input) -> Output {
    var dummyData = [String]()
    let searchHistory = PublishSubject<[String]>()
    let searchHistorySelected = PublishSubject<String>()
    let searchResult = BehaviorSubject<[Place]>(value: [])
    
    
    let searchSuccess = PublishSubject<[Place]>()
    let searchError = PublishSubject<SearchAPIError>()
    let saveSearchText = PublishSubject<Void>()
    let model = PostSearchModel()
    
    
    input.searchButtonDidTap.flatMapLatest { [weak self] in
      model.search($0, self?.locationManager.locationChanged.value, nextPage: false)
    }.subscribe(onNext: { result in
      switch result {
      case .success(let places):
        searchSuccess.onNext(places)
        saveSearchText.onNext(())
      case .failure(let error):
        searchError.onNext(error)
      }
    }).disposed(by: disposeBag)
    
    input.searchButtonDidTap
      .subscribe(onNext: { [weak self] _ in
        self?.isPaging = false
      }).disposed(by: disposeBag)
    
    input.searchHistoryItemDidTap
      .subscribe(onNext: { [weak self] _ in
        self?.isPaging = false
      }).disposed(by: disposeBag)
    
    input.resultTableViewReachedBottom
      .subscribe(onNext: { [weak self] _ in
        self?.isPaging = true
      }).disposed(by: disposeBag)
    

    input.resultTableViewReachedBottom
      .observeOn(MainScheduler.instance)
      .filter{ $0 == true }
      .withLatestFrom(input.searchButtonDidTap)
      .flatMapLatest{ [weak self] in
        model.search($0, self?.locationManager.locationChanged.value, nextPage: true)
      }.subscribe(onNext: {  result in
        switch result {
        case .success(let places):
          searchSuccess.onNext(places)
        case .failure(let error):
          searchError.onNext(error)
        }
      }).disposed(by: disposeBag)
    
//    saveSearchText.withLatestFrom(input.searchButtonDidTap)
//      .subscribe(onNext:{ [weak self] in
//        guard let self = self else { return }
//        searchHistory.onNext(self.save($0, &dummyData))
//      }).disposed(by: disposeBag)
      
    input.searchButtonDidTap
      .filter { $0.count > 0 }
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        searchHistory.onNext(self.save($0, &dummyData))
      }).disposed(by: disposeBag)
    
    input.removeSearchHistoryItem
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        searchHistory.onNext(self.remove($0, &dummyData))
      }).disposed(by: disposeBag)
    
    input.removeAllButtonDidTap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        // TODO: 검색어 삭제
        searchHistory.onNext(self.remove(nil, &dummyData))
      }).disposed(by: disposeBag)
    
    input.searchHistoryItemDidTap
      .map { dummyData.reversed()[$0.row] }
      .bind(to: input.searchButtonDidTap, searchHistorySelected)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(searchResult, searchSuccess)
      .sample(searchSuccess)
      .map { current, next in
        return self.isPaging ? current + next : next
      }.bind(to: searchResult)
      .disposed(by: disposeBag)
        

    let postMapViewModel = input.searchResultItemDidTap
      .map { _ in return PostMapViewModel()}
    
    let output = Output(searchHistory: searchHistory,
                        searchResult: searchResult,
                        searchError: searchError,
                        postMapView: postMapViewModel,
                        searchHistorySelected: searchHistorySelected)
    return output
  }
  
  private func save(_ text: String, _ logs: inout [String]) -> [String] {
    for i in 0..<logs.count {
      if logs[i] == text {
        logs.remove(at: i)
        break
      }
    }
    
    print(logs)
    logs.append(text)
    if logs.count <= 5 {
      return logs.reversed()
    }
    
    var lastFive = [String]()
    for i in (logs.count-5)..<logs.count {
      lastFive.append(logs[i])
    }
    return lastFive.reversed()
  }
  
  private func remove(_ index: Int?, _ logs: inout [String]) -> [String] {
    guard index != nil else {
      logs.removeAll()
      return logs
    }
    
    logs.remove(at: index!)
    if logs.count <= 5 {
      return logs.reversed()
    }
    
    var lastFive = [String]()
    for i in (logs.count-5)..<logs.count {
      lastFive.append(logs[i])
    }
    return lastFive.reversed()
    
    
    return logs
  }
  
}
