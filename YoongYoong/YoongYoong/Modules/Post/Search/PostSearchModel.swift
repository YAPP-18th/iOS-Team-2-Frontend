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
  
  // TODO: repo
  private let provider: SearchAPIProvider
  
  init(_ provider: SearchAPIProvider = .init()) {
    self.provider = provider
  }
  
  private var logs = [String]()
  private var page = 1
  private var isEnd = false
  
  // TODO: Pagination
  func search(_ text: String, _ coordinate: CLLocationCoordinate2D?, nextPage: Bool) -> Observable<Result<[Place], SearchAPIError>>  {
    guard let coordinate = coordinate else { return .just(.failure(.error("coordinate error")))}
    
    if nextPage {
      page += 1
    } else {
      page = 1
      isEnd = false
      logs.append(text)
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
  func remove(_ index: Int, removeAll: Bool) -> Observable<Result<Void, Error>>{
    return .just(.success(()))
  }
  func save(_ text: String) -> Observable<Result<Void, Error>>{
    return .just(.success(()))
  }
  func load() -> Observable<Result<[String], Error>> {
    return .just(.success([]))
  }
  
  
  
}
