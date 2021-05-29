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
  case apiError(Int)
  case jsonParsingError
  
  var message: String {
    switch self {
    case .error(let msg):
      return msg
    case .apiError(let statusCode):
      return "API Error. status code: \(statusCode)"
    case .jsonParsingError:
      return "JSON Parsing Error"
    }
  }
  
}

class SearchService {
  private let provider: MoyaProvider<SearchRouter>
  init(provider: MoyaProvider<SearchRouter> = .init()) {
    self.provider = provider
  }
  
  func searchResults(text: String, lat: String, long: String, page: Int, sort: Bool = true) -> Observable<Result<SearchAPIResponse, SearchAPIError>> {
    return provider.rx.request(.search(text: text, lat: lat, long: long, page: page, sort: sort))
      .asObservable()
      .map { response -> Result<SearchAPIResponse, SearchAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(SearchAPIResponse.self, from: response.data)
            return .success(results)
          } catch {
            return .failure(.jsonParsingError)
          }
        // 잘못된 parameter를 전달한 경우, parameter가 누락된 경우
        default:
          return .failure(.apiError(response.statusCode))
        }
      }

  }
  
}
