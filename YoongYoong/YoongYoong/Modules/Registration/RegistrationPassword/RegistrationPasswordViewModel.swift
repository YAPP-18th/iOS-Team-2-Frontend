//
//  RegistrationPasswordViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationPasswordViewModel : ViewModel, ViewModelType {
  
  let isMarketingAgree: Bool
  let email: String
  
  init(
    isMarketingAgree: Bool,
    email: String
  ) {
    self.isMarketingAgree = isMarketingAgree
    self.email = email
  }
  
  struct Input {
    let passwordCheck: Observable<String>
    let confirmPasswordCheck: Observable<(String, String)>
    let next: Observable<String>
  }
  
  struct Output {
    let validPassword: Driver<Bool>
    let matchPassword: Driver<Bool>
    let registrationProfile: Driver<RegistrationProfileViewModel>
  }
  func transform(input: Input) -> Output {
    let registrationProfile = input.next.asDriver(onErrorJustReturn: "").map { password -> RegistrationProfileViewModel in
      let viewModel = RegistrationProfileViewModel(
        isMarketingAgree: self.isMarketingAgree,
        email: self.email,
        password: password
      )
      return viewModel
    }
    
    let validPassword = input.passwordCheck
      .flatMapLatest{ [weak self] password in
        self?.validatePassword(password) ?? .empty()
      }
    let matchPassword = input.confirmPasswordCheck.map {
      return $0 == $1
    }
    
    return .init(
      validPassword: validPassword.asDriver(onErrorDriveWith: .empty()),
      matchPassword: matchPassword.asDriver(onErrorDriveWith: .empty()),
      registrationProfile: registrationProfile
    )
  }
  
  func validatePassword(_ password: String) -> Observable<Bool> {
    return Observable.create { observer in
      let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
      // let passwordRegEx = "^[a-zA-Z0-9!@#$%^&*()?_~.|-]{10,20}$"
      let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
      observer.onNext(predicate.evaluate(with: password))
      return Disposables.create()
    }
    
  }
}
