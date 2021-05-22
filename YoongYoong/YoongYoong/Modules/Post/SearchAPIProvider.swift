//
//  SearchAPIProvider.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/19.
//

import Foundation
import Moya
import RxSwift


enum SearchAPIError: Error {
  case error(String)
  
  var message: String {
    switch self {
    case .error(let msg):
      return msg
    }
  }
  
}

class SearchAPIProvider {
  private let provider: MoyaProvider<SearchAPI>
  init(provider: MoyaProvider<SearchAPI> = .init()) {
    self.provider = provider
  }
  
  // TODO: Pagination
  func searchResults(text: String, lat: String, long: String, page: Int, sort: Bool = true) -> Observable<Result<SearchAPIResponseJSON, SearchAPIError>> {
    return provider.rx.request(.search(text: text, lat: lat, long: long, page: page, sort: sort))
      .asObservable()
      .map { response -> Result<SearchAPIResponseJSON, SearchAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(SearchAPIResponseJSON.self, from: response.data)
            return .success(results)
          } catch {
            return .failure(.error("JSON Parsing Error"))
          }
        case 400:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500:
          // parameter가 누락된 경우 
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }

  }
  
}
