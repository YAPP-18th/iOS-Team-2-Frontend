//
//  AuthService.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation
import Moya
import RxSwift

protocol AuthorizeServiceType: class {
  
  func checkEmailDuplicate(_ param: CheckEmailDuplicateRequest) -> Observable<Bool>
  func checkNickNameDuplicate(_ param: String) -> Observable<Bool>

  func signup(_ param: SignupRequest) -> Observable<Response>
  func login(_ param : LoginRequest) -> Observable<Response>
  func guest() -> Observable<Response>
  func deletAccount(id: Int) -> Observable<Response>
}

class AuthorizeService: AuthorizeServiceType {
  private let provider: MoyaProvider<AuthRouter>
  init(provider: MoyaProvider<AuthRouter>) {
    self.provider = provider
  }
}

extension AuthorizeService {
  func checkEmailDuplicate(_ param: CheckEmailDuplicateRequest) -> Observable<Bool> {
    return provider.rx.request(.emailCheck(param: param))
      .asObservable()
      .map { response -> Bool in
        (200...300).contains(response.statusCode)
      }
  }
  func checkNickNameDuplicate(_ param: String) -> Observable<Bool> {
    return provider.rx.request(.nickNameCheck(param: param))
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
  func guest() -> Observable<Response> {
    provider.rx.request(.guest)
      .asObservable()
  }
  func deletAccount(id : Int) -> Observable<Response> {
    provider.rx.request(.deleteAccount(id: id))
      .asObservable()
  }
}
