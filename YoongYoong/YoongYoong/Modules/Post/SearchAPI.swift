//
//  SearchService.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/18.
//

import Foundation
import Moya

enum SearchAPI {
  static private let apiKey = "a30bb297576560dd0618e9d8e05bedb8"
  case search(text: String,
              lat: String,
              long: String,
              page: Int,
              sort: Bool)
}

extension SearchAPI: TargetType {
  var baseURL: URL { URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json")! }
  var path: String { "" }
  var method: Moya.Method { .get }
  var sampleData: Data { Data() }
  
  var task: Task {
    switch self {
    case .search(let text, let lat, let long, let page, let sort):
      return .requestParameters(parameters: [
        "category_group_code": "FD6",
        "query": text,
        "x": long,
        "y": lat,
        "page": page,
        "sort": sort ? "distance" : "accuracy"
      ], encoding: URLEncoding.default)
      
    }
    
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return ["Authorization": "KakaoAK \(SearchAPI.apiKey)"]
    }
  }
}
