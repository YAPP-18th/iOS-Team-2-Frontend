//
//  PostService.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/29.
//

import Foundation
import Moya
import RxSwift

enum PostAPIError: Error {
  case error(String)
  
  var message: String {
    switch self {
    case .error(let msg):
      return msg
    }
  }
  
}

final class PostService {
  
  private let provider: MoyaProvider<PostRouter>
  init(provider: MoyaProvider<PostRouter> = .init()) {
    self.provider = provider
  }
  
  func fetchAllPosts() -> Observable<Result<BaseResponse<[PostResponse]>, PostAPIError>> {
    return provider.rx.request(.fetchPostList).asObservable()
      .map { response -> Result<BaseResponse<[PostResponse]>, PostAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(BaseResponse<[PostResponse]>.self, from: response.data)
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
