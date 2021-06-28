//
//  FindPasswordInputViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/28.
//

import Foundation
import RxCocoa
import RxSwift

class FindPasswordInputViewModel: ViewModel, ViewModelType {
  struct Input {
    let passwordCheck: Observable<String>
    let confirmPasswordCheck: Observable<(String, String)>
    let next: Observable<String>
  }
  
  struct Output {
    let validPassword: Driver<Bool>
    let matchPassword: Driver<Bool>
//    let registrationProfile: Driver<RegistrationProfileViewModel>
  }
  func transform(input: Input) -> Output {
    let validPassword = input.passwordCheck
      .flatMapLatest{ [weak self] password in
        self?.validatePassword(password) ?? .empty()
      }
    let matchPassword = input.confirmPasswordCheck.map {
      return $0 == $1
    }
    
    return .init(
      validPassword: validPassword.asDriver(onErrorDriveWith: .empty()),
      matchPassword: matchPassword.asDriver(onErrorDriveWith: .empty())
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
