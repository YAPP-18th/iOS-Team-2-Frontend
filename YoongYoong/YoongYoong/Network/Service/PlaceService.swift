//
//  PlaceService.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/23.
//

import Foundation
import Moya
import RxSwift

protocol PlaceServiceType {}

final class PlaceService {
  let provider: APIProvider
  init(provider: APIProvider = .init(plugins:[NetworkLoggerPlugin()])) {
    self.provider = provider
  }
  
  func requestReviewCount() -> Observable<Response> {
    return provider.rx.request(.fetchReviewCountAll(()))
      .asObservable()

  }
}
