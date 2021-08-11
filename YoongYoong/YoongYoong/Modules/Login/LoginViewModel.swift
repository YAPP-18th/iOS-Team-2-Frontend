//
//  LogInViewModel.swift
//  YoongYoong
//
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import AuthenticationServices

class LoginViewModel : ViewModel, ViewModelType {
    private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
    
    struct Input {
        let param : Observable<(String,String)>
        let registration: Observable<Void>
        let login: Observable<Void>
        let guest: Observable<Void>
        let findPassword: Observable<Void>
    }
    
    struct Output {
        let loginResult: Observable<(Bool, LoginResponse?)>
      let appleLoginResult: Observable<(Bool, LoginResponse?)>
        let guestLoginResult: Observable<(Bool, LoginResponse?)>
        let registration: Driver<RegistrationTermsViewModel>
        let findPassword: Driver<FindPasswordViewModel>
    }
  
  let appleLogin = PublishSubject<String>()
    
    func transform(input: Input) -> Output {
        let registrationResult = input.login
            .withLatestFrom(input.param)
            .flatMapLatest{
                self.service.login(.init(email: $0.0, password: $0.1))
            }
            .map{ ((200...300).contains($0.statusCode) ,try? $0.map(LoginResponse.self, atKeyPath: "data"))}
        
      let appleLoginResult = self.appleLogin
        .flatMapLatest {
          self.service.appleLogin(.init(socialId: $0))
        }.map{ ((200...300).contains($0.statusCode) ,try? $0.map(LoginResponse.self, atKeyPath: "data"))}
      
        let guestLogin = input.guest
            .flatMap(self.service.guest)
            .map{ ((200...300).contains($0.statusCode) ,try? $0.map(LoginResponse.self, atKeyPath: "data"))}
        
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
          appleLoginResult: appleLoginResult,
            guestLoginResult: guestLogin,
            registration: registration,
            findPassword: findPassword
        )
    }
}
