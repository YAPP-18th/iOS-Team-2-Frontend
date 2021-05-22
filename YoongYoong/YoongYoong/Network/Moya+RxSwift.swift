//
//  Moya+RxSwift.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import RxSwift
import Moya
import UIKit

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    public func filter401StatusCode() -> Single<Element> {
        return flatMap { response in
            guard response.statusCode != 401 else {
                throw MoyaError.statusCode(response)
            }
            return .just(response)
        }
    }

    public func filter500StatusCode() ->Single<Element> {
        return flatMap { response in
            guard response.statusCode != 500 else {
                AlertAction.shared.showAlertView(title: "서버 오류가 발생했습니다.", grantMessage: "확인",denyMessage: "확인")
                throw MoyaError.statusCode(response)
            }
            return .just(response)
        }
    }
    public func alert404StatusCode(_ title: String? = nil) -> Single<Element> {
        return flatMap { response in
            if response.statusCode == 404 {
              AlertAction.shared.showAlertView(title:title ?? "정보를 불러올 수 없습니다!", grantMessage: "확인", denyMessage: "확인")
            }
            return .just(response)
        }
    }
}
extension Encodable{
  func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
      }
      return dictionary
  }
}
