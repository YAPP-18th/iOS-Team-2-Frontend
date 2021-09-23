//
//  APIProvider.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/08/28.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum APIError: Error {
  case tokenExpired
  case needLogin
  case general(Error)
}

class APIProvider: MoyaProvider<APIRouter> {
  var isRefreshing = false
  private var pendingRequests: [DispatchWorkItem] = []
  
  func saveRequest(_ block: @escaping () -> Void) {
    pendingRequests.append(DispatchWorkItem(block: {
      block()
    }))
  }
  
  func executeAllSavedRequests() {
    pendingRequests.forEach ( { DispatchQueue.global().async(execute: $0) })
    pendingRequests.removeAll()
  }
  
}

extension Reactive where Base: APIProvider {
  func request(_ token: Base.Target, callBackQueue: DispatchQueue? = nil) -> Single<Response> {
    return Single.create { [weak base] single in
      var pendingCancellable: Cancellable?
      let disposable = Disposables.create { pendingCancellable?.cancel() }
      
      func rescheduleCurrentRequest() {
        base?.saveRequest( {
          pendingCancellable = base?.request(token, callbackQueue: callBackQueue, progress: nil) { result in
            switch result {
            case .success(let response):
              single(.success(response))
            case .failure(let error):
              single(.error(error))
            }
          }
        })
      }
      
      func refreshAccessToken(request: RefreshTokenRequest) -> Cancellable? {
        base?.isRefreshing = true
        return base?.request(.refreshToken(param: request), completion: { result in
          //Todo: update Token
          switch result {
          case .success(let response):
            if let data = try? JSONDecoder().decode(BaseResponse<LoginResponse>.self, from: response.data).data {
              base?.isRefreshing = false
            LoginManager.shared.makeLoginStatus(accessToken: data.accessToken, refreshToken: data.refreshToken)
            base?.executeAllSavedRequests()
          } else {
            base?.isRefreshing = false
            single(.error(APIError.tokenExpired))
          }
          case .failure(let error):
            base?.isRefreshing = false
            single(.error(APIError.general(error)))
          }
          
        })
      }
      
      if (base?.isRefreshing ?? false) {
        rescheduleCurrentRequest()
        return disposable
      }
      
      let cancellableToken = base?.request(token, callbackQueue: callBackQueue, progress: nil) { result in
        let loginManager = LoginManager.shared
        switch result {
        case .success(let response):
          if case .bearer = token.authorizationType,
             !(base?.isRefreshing ?? false),
             response.statusCode == 403 {
            switch loginManager.loginStatus {
            case .logined:
              if loginManager.tokenExpired && loginManager.refreshTokenExpired {
                single(.error(APIError.tokenExpired))
              } else if loginManager.tokenExpired,
                        let refreshToken = loginManager.refreshToken,
                        let id = UserDefaultStorage.userId {
                rescheduleCurrentRequest()
                _ = refreshAccessToken(request: .init(id: id, token: refreshToken))
              } else {
                single(.error(APIError.tokenExpired))
              }
            default:
              // 로그인 필요 서비스
              single(.error(APIError.needLogin))
            }
          } else if (base?.isRefreshing ?? false) {
            rescheduleCurrentRequest()
          } else {
            single(.success(response))
          }
        case .failure(let error):
          single(.error(APIError.general(error)))
        }
      }
      
      return Disposables.create {
        cancellableToken?.cancel()
      }
    }
  }
}
