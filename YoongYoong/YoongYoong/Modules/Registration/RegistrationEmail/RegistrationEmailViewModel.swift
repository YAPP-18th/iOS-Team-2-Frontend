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
  let isAppleRegistration: Bool
  
  init(isAppleRegistration: Bool, isMarketingAgree: Bool) {
    self.isAppleRegistration = isAppleRegistration
    self.isMarketingAgree = isMarketingAgree
  }
  
  private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let next: Observable<String>
    let emailCheck: Observable<String>
  }
  struct Output {
    let defaultEmail: Driver<String?>
    let registrationPassword: Observable<RegistrationPasswordViewModel>
    let registrationProfile: Observable<RegistrationProfileViewModel>
    let checkEmailResult: Driver<Bool>
    let validEmail: Driver<Bool>
  }
  
  let registrationPassword = PublishSubject<RegistrationPasswordViewModel>()
  let registrationProfile = PublishSubject<RegistrationProfileViewModel>()
  
  func transform(input: Input) -> Output {
    input.next.subscribe(onNext: { email in
      if self.isAppleRegistration {
        AppleRegistration.shared.email = email
        let viewModel = RegistrationProfileViewModel(isAppleRegistration: true, isMarketingAgree: self.isMarketingAgree, email: email, password: "")
        self.registrationProfile.onNext(viewModel)
      } else {
        let viewModel = RegistrationPasswordViewModel(
          isMarketingAgree: self.isMarketingAgree,
          email: email
        )
        self.registrationPassword.onNext(viewModel)
      }
    }).disposed(by: disposeBag)
    
    let result = input.emailCheck
      .flatMapLatest{ [weak self] email in
        self?.service.checkEmailDuplicate(.init(email: email)) ?? .empty()
      }
    
    let validEmail = input.emailCheck
      .flatMapLatest { [weak self] email in
        return self?.validateEmailPattern(text: email) ?? .empty()
      }
    return .init(
      defaultEmail: .just(self.isAppleRegistration ? AppleRegistration.shared.email : nil),
      registrationPassword: self.registrationPassword,
      registrationProfile: self.registrationProfile,
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
