//
//  LogInViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewModel : ViewModel, ViewModelType {
  private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let param : Observable<(String,String)>
    let registration: Observable<Void>
    let login: Observable<Void>
    let guest: Observable<Void>
    let findPassword: Observable<Void>
    let kakaoLogin: Observable<Void>
  }
  struct Output {
    let loginResult: Observable<(Bool, LoginResponse?)>
    let guestLoginResult: Observable<(Bool, LoginResponse?)>
    let registration: Driver<RegistrationTermsViewModel>
    let findPassword: Driver<FindPasswordViewModel>
  }
  func transform(input: Input) -> Output {
    weak var `self` = self
    let registrationResult = input.login
      .withLatestFrom(input.param)
      .flatMapLatest{
        self?.service.login(.init(email: $0.0, password: $0.1)) ?? .empty()
      }
      .map{ ((200...300).contains($0.statusCode) ,try? $0.map(LoginResponse.self, atKeyPath: "data"))}
    
    let guestLogin = input.guest
      .flatMap(self!.service.guest)
      .map{ ((200...300).contains($0.statusCode) ,try? $0.map(LoginResponse.self, atKeyPath: "data"))}
    
    input.kakaoLogin.subscribe(onNext: { _ in
      guard let self = self else { return }
      self.kakaoLogin()
    }).disposed(by: disposeBag)
    
    let registration = input.registration.asDriver(onErrorJustReturn: ()).map { () -> RegistrationTermsViewModel in
      let viewModel = RegistrationTermsViewModel()
      return viewModel
    }
    
    let findPassword = input.findPassword.asDriver(onErrorJustReturn: ()).map { () -> FindPasswordViewModel in
      let viewModel = FindPasswordViewModel()
      return viewModel
    }
    
    return .init(
      loginResult: registrationResult,
      guestLoginResult: guestLogin,
      registration: registration,
      findPassword: findPassword
    )
  }
  
  private func kakaoLogin() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { token, error in
        if let error = error {
          print(error.localizedDescription)
        } else if let token = token {
          print(token)
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { token, error in
        if let error = error {
          print(error.localizedDescription)
        } else if let token = token {
          print(token)
        }
      }
    }
  }
}
