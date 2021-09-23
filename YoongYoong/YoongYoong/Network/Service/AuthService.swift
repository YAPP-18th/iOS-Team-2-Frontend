//
//  AuthService.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation
import Moya
import RxSwift

enum AuthAPIError: Error {
  case error(String)
  
  var message: String {
    switch self {
    case .error(let msg):
      return msg
    }
  }
}
protocol AuthorizeServiceType: AnyObject {
  
  func checkEmailDuplicate(_ param: CheckEmailDuplicateRequest) -> Observable<Bool>
  func checkNickNameDuplicate(_ param: String) -> Observable<Bool>

  func signup(_ param: SignupRequest, image: Data) -> Observable<Response>
  func signup(_ param: AppleRegistrationDTO) -> Observable<Response>
  func login(_ param : LoginRequest) -> Observable<Response>
  func appleLogin(_ param: AppleLoginRequest) -> Observable<Response>
  func guest() -> Observable<Response>
  func deletAccount(id: Int) -> Observable<Response>
  func findPassword(_ param: FindPasswordRequest) -> Observable<Bool>
  func findPasswordCode(_ param: FindPasswordCodeRequest) -> Observable<Bool>
  func resetPassword(_ param: ResetPasswordRequest) -> Observable<Bool>
  
  func getProfile(got: @escaping () -> Void)
  func editProfile(_ param: ModifyProfileParam) -> Observable<Bool>
}

class AuthorizeService: AuthorizeServiceType {
  
  let disposeBag = DisposeBag()
  private let provider: APIProvider
  init(provider: APIProvider) {
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

  func signup(_ param: SignupRequest, image: Data) -> Observable<Response> {
    provider.rx.request(.register(param: param, image: image))
      .asObservable()
  }
  
  func signup(_ param: AppleRegistrationDTO) -> Observable<Response> {
    provider.rx.request(.appleRegister(param: param))
      .asObservable()
  }
  
  func login(_ param: LoginRequest) -> Observable<Response> {
    provider.rx.request(.login(param: param))
      .asObservable()
  }
  
  func appleLogin(_ param: AppleLoginRequest) -> Observable<Response>{
    provider.rx.request(.appleLogin(param: param))
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
  
  func findPassword(_ param: FindPasswordRequest) -> Observable<Bool> {
    return provider.rx.request(.findPassword(param: param))
      .asObservable()
      .map { response -> Bool in
        (200...300).contains(response.statusCode)
      }
  }
  
  func findPasswordCode(_ param: FindPasswordCodeRequest) -> Observable<Bool> {
    return provider.rx.request(.findPasswordCode(param: param))
      .asObservable()
      .map { response -> Bool in
        (200...300).contains(response.statusCode)
      }
  }
  
  func resetPassword(_ param: ResetPasswordRequest) -> Observable<Bool> {
    return provider.rx.request(.resetPassword(param: param))
      .asObservable()
      .map { (200...300).contains($0.statusCode) }
  }
  
  func getProfile(got: @escaping () -> Void) {
    provider.rx.request(.profile)
      .asObservable()
      .catchErrorJustReturn(Response(statusCode: 403, data: Data()))
      .filter { (200...300).contains($0.statusCode) }
      .map { response -> UserInfo in
        let result = try! JSONDecoder().decode(BaseResponse<UserInfo>.self, from: response.data)
        if let id = result.data?.id {
          UserDefaultHelper.set(id, forKey: .userId)
        }
        return result.data!
      }.do { _ in
        got()
      }
      .bind(to: globalUser)
      .disposed(by: self.disposeBag)
  }
  
  func editProfile(_ param: ModifyProfileParam) -> Observable<Bool> {
    return provider.rx.request(.modifyProfile(param: param))
      .asObservable()
      .map { (200...300).contains($0.statusCode) }
  }
}
