//
//  RegistrationEmailViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class RegistrationEmailViewModel: ViewModel, ViewModelType {
  let isMarketingAgree: Bool
  
  init(isMarketingAgree: Bool) {
    self.isMarketingAgree = isMarketingAgree
  }
  
  private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let next: Observable<Void>
    let emailCheck: Observable<String>
  }
  struct Output {
    let registrationPassword: Driver<RegistrationPasswordViewModel>
    let checkEmailResult: Driver<Bool>
  }
  func transform(input: Input) -> Output {
    weak var `self` = self
    let registrationPassword = input.next.asDriver(onErrorJustReturn: ()).map { () -> RegistrationPasswordViewModel in
      let viewModel = RegistrationPasswordViewModel()
      return viewModel
    }
    let result = input.emailCheck
      .flatMapLatest{ email in
        self?.service.checkEmailDuplicate(.init(email: email)) ?? .empty()
      }
    return .init(
      registrationPassword: registrationPassword, checkEmailResult: result.asDriver(onErrorDriveWith: .empty())
    )
  }
}
