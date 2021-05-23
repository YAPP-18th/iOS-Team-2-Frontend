//
//  PostSearchModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/19.
//

import Foundation
import CoreLocation
import RxSwift
import Moya

class PostSearchModel {
  
  private let provider: SearchService
  private var searchHistory = [String]()
  
  init(_ provider: SearchService = .init()) {
    self.provider = provider
    searchHistory = self.loadSearchHistory().reversed()
  }
  
  private var page = 1
  private var isEnd = false
  
  func search(_ text: String, _ coordinate: CLLocationCoordinate2D?, nextPage: Bool) -> Observable<Result<[Place], SearchAPIError>>  {
    guard let coordinate = coordinate else { return .just(.failure(.error("coordinate error")))}
    
    if nextPage {
      page += 1
    } else {
      page = 1
      isEnd = false
    }
    if isEnd { return .just(.success([])) }

    return provider.searchResults(text: text,
                           lat:  String(coordinate.latitude),
                           long: String(coordinate.longitude),
                           page: page).map { [weak self] result in
                            switch result {
                            case .success(let response):
                              self?.isEnd = response.meta.isEnd
                              return .success(response.documents)
                            case .failure(let error):
                              return .failure(error)
                            }
                            
                           }
    
  }
  
  // 검색어
  func searchItem(at index: Int) -> String {
    return searchHistory[(searchHistory.count-1)-index]
  }
  
  func remove(_ index: Int?, _ completion: @escaping ([String]) -> ()) {
    if index == nil {
      searchHistory.removeAll()
    } else {
      searchHistory.remove(at: (searchHistory.count-1)-index!)
    }
    completion(searchHistory.reversed())
    UserDefaultHelper.set(searchHistory, forKey: .searchHistory)
  }
  
  func add(_ text: String, _ completion: @escaping ([String]) -> ()) {
    if searchHistory.contains(text) {
      var index = 0
      for i in 0..<searchHistory.count {
        if searchHistory[i] == text {
          index = i
        }
      }
      searchHistory.remove(at: index)
      searchHistory.append(text)
      
    } else {
      if searchHistory.count < 5 {
        searchHistory.append(text)
      } else {
        searchHistory.remove(at: 0)
        searchHistory.append(text)
      }
    }
    completion(searchHistory.reversed())
    UserDefaultHelper.set(searchHistory, forKey: .searchHistory)

  }
  
  func loadSearchHistory() -> [String] {
    guard let history = UserDefaultStorage.searchHistory else { return [] }
    return history
  }

}
