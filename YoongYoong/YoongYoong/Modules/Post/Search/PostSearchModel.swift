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
  
  private let searchService: SearchService
  private let placeService: PlaceService
  private var searchHistory = [String]()
  
  init(_ searchService: SearchService = .init(), _ placeService: PlaceService = .init()) {
    self.searchService = searchService
    self.placeService = placeService
    searchHistory = self.loadSearchHistory().reversed()
    getAllReviewCounts()
  }
  
  private var page = 1
  private var isEnd = false
  private var reviewCounts = [PlaceReviewCount]()
  
  private func getAllReviewCounts() {
    placeService.requestReviewCount()
      .filterSuccessfulStatusCodes()
      .map { try? JSONDecoder().decode(AllPlaceReviewCountResponse.self, from: $0.data) }
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.reviewCounts = $0!.data
      }).disposed(by: DisposeBag())

  }
  
  private func reviewCount(_ name: String, _ location: String) -> Int? {
    for reviewCount in reviewCounts {
      if reviewCount.name == name && reviewCount.location == location {
        return reviewCount.reviewCount
      }
    }
    return nil
  }
  
  func search(_ text: String, _ coordinate: CLLocationCoordinate2D?, nextPage: Bool) -> Observable<Result<[Place], SearchAPIError>>  {
    guard let coordinate = coordinate else { return .just(.failure(.error("위치 접근 권한")))}
    
    if nextPage {
      page += 1
    } else {
      page = 1
      isEnd = false
    }
    if isEnd { return .just(.success([])) }
    
    return searchService.searchResults(text: text,
                                  lat:  String(coordinate.latitude),
                                  long: String(coordinate.longitude),
                                  page: page).map{ [weak self] result -> Result<[Place], SearchAPIError> in
                                    switch result {
                                    case .success(let response):
                                      self?.isEnd = response.meta.isEnd
                                      let places = response.documents.map { Place(name: $0.name,
                                                                                  roadAddress: $0.roadAddress,
                                                                                  address: $0.address,
                                                                                  distance: $0.distance,
                                                                                  latitude: $0.latitude,
                                                                                  longtitude: $0.longtitude,
                                                                                  reviewCount: self?.reviewCount($0.name, $0.address) ?? 0)}
                                      return .success(places)
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
    return history.reversed()
  }

}
