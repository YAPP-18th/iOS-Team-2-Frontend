//
//  PlaceService.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/23.
//

import Foundation
import Moya
import RxSwift

class PlaceService {
  let provider: MoyaProvider<PlaceRouter>
  init(provider: MoyaProvider<PlaceRouter> = .init()) {
    self.provider = provider
  }
  
  func requestReviewCount() -> Observable<Response> {
    return provider.rx.request(.fetchReviewCountAll(()))
      .asObservable()

  }
}
