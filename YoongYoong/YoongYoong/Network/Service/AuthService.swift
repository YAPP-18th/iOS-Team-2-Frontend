//
//  AuthService.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation
import Moya
import RxSwift

protocol SignupRequestServiceType: class {
  
  func checkEmailDuplicate(_ param: CheckEmailDuplicateRequest) -> Observable<Bool>
  func signup(_ param: SignupRequest) -> Observable<Response>
  func login(_ param : LoginRequest) -> Observable<Response>
}

class SignupRequestService: SignupRequestServiceType {
  private let provider: MoyaProvider<AuthRouter>
  init(provider: MoyaProvider<AuthRouter>) {
    self.provider = provider
  }
}

extension SignupRequestService {
  func checkEmailDuplicate(_ param: CheckEmailDuplicateRequest) -> Observable<Bool> {
    return provider.rx.request(.emailCheck(param: param))
      .asObservable()
      .map { response -> Bool in
        (200...300).contains(response.statusCode)
      }
  }
  func signup(_ param: SignupRequest) -> Observable<Response> {
    provider.rx.request(.register(param: param))
      .asObservable()
      
  }
  func login(_ param: LoginRequest) -> Observable<Response> {
    provider.rx.request(.login(param: param))
      .asObservable()
  }
}
