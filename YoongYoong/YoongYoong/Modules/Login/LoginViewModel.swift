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
class LoginViewModel : ViewModel, ViewModelType {
  private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let param : Observable<(String,String)>
    let registration: Observable<Void>
    let login: Observable<Void>
  }
  struct Output {
    let loginResult: Observable<(Bool ,String?)>
    let registration: Driver<RegistrationTermsViewModel>
  }
  func transform(input: Input) -> Output {
    weak var `self` = self
    let registrationResult = input.login
      .withLatestFrom(input.param)
      .flatMapLatest{
        self?.service.login(.init(email: $0.0, password: $0.1)) ?? .empty()
      }
      .map{ ((200...300).contains($0.statusCode) ,try? $0.map(String.self , atKeyPath: "token") ?? nil)}
    let registration = input.registration.asDriver(onErrorJustReturn: ()).map { () -> RegistrationTermsViewModel in
      let viewModel = RegistrationTermsViewModel()
      return viewModel
    }
    return .init(
      loginResult: registrationResult,
      registration: registration
    )
  }
}
