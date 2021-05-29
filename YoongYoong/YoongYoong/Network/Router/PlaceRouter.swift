//
//  PlaceRouter.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation

import Moya

enum PlaceRouter {
  case fetchPlaceList(param : PlaceRequest)
  case fetchReviewCount(name: String)
  case fetchReviewCountAll(Void)
}


extension PlaceRouter: TargetType {
  public var baseURL: URL {
    return URL(string: "http://52.78.137.81:8080")!
  }
  
  var path: String {
    switch self {
    case .fetchPlaceList(param: let param):
      return "/place"
    case .fetchReviewCount(name: let name):
      return "/place/review-count"
    case .fetchReviewCountAll():
      return "/place/review-count/all"
    }
  }
  
  var method: Moya.Method {
    switch self {
    
    case .fetchReviewCount,
         .fetchPlaceList,
         .fetchReviewCountAll:
      return .get

    }
  }
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
 
    case .fetchPlaceList(param: let param):
      return .requestJSONEncodable(param)
    case .fetchReviewCount(name: let name):
      return .requestParameters(parameters: try! ["name" : name].asParameters(), encoding: JSONEncoding.default)
    case .fetchReviewCountAll():
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json",
              "token" : UserDefaultHelper<String>.value(forKey: .accessToken)!]
    }
  }
}

