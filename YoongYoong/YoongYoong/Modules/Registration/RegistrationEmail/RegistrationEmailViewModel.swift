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
    let next: Observable<String>
    let emailCheck: Observable<String>
  }
  struct Output {
    let registrationPassword: Driver<RegistrationPasswordViewModel>
    let checkEmailResult: Driver<Bool>
    let validEmail: Driver<Bool>
  }
  func transform(input: Input) -> Output {
    let registrationPassword = input.next.asDriver(onErrorJustReturn: "").map { email -> RegistrationPasswordViewModel in
      let viewModel = RegistrationPasswordViewModel(
        isMarketingAgree: self.isMarketingAgree,
        email: email
      )
      return viewModel
    }
    let result = input.emailCheck
      .flatMapLatest{ [weak self] email in
        self?.service.checkEmailDuplicate(.init(email: email)) ?? .empty()
      }
    
    let validEmail = input.emailCheck
      .flatMapLatest { [weak self] email in
        return self?.validateEmailPattern(text: email) ?? .empty()
      }
    return .init(
      registrationPassword: registrationPassword,
      checkEmailResult: result.asDriver(onErrorDriveWith: .empty()),
      validEmail: validEmail.asDriver(onErrorDriveWith: .empty())
    )
  }
  
  func validateEmailPattern(text: String) -> Observable<Bool> {
    return Observable.create { observer in
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

      let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
      let result = emailTest.evaluate(with: text)
      observer.onNext(result)
      return Disposables.create()
    }
    
  }
}
