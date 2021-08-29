//
//  FindPasswordInputViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/28.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

class FindPasswordInputViewModel: ViewModel, ViewModelType {
  private let service : AuthorizeServiceType = AuthorizeService(provider: APIProvider(plugins:[NetworkLoggerPlugin()]))
  
  let email: String
  let code: String
  
  init(email: String, code: String) {
    self.email = email
    self.code = code
  }
  
  struct Input {
    let passwordCheck: Observable<String>
    let confirmPasswordCheck: Observable<(String, String)>
    let next: Observable<String>
  }
  
  struct Output {
    let validPassword: Driver<Bool>
    let matchPassword: Driver<Bool>
    let resetPasswordSuccess: Observable<Void>
  }
  
  let resetPasswordSuccess = PublishSubject<Void>()
  
  func transform(input: Input) -> Output {
    let validPassword = input.passwordCheck
      .flatMapLatest{ [weak self] password in
        self?.validatePassword(password) ?? .empty()
      }
    let matchPassword = input.confirmPasswordCheck.map {
      return $0 == $1
    }
    
    input.next.subscribe(onNext: { newPassword in
      let param = ResetPasswordRequest(
        email: self.email,
        code: self.code,
        password: newPassword
      )
      self.resetPassword(param)
    }).disposed(by: disposeBag)
    
    return .init(
      validPassword: validPassword.asDriver(onErrorDriveWith: .empty()),
      matchPassword: matchPassword.asDriver(onErrorDriveWith: .empty()),
      resetPasswordSuccess: self.resetPasswordSuccess
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
  
  private func resetPassword(_ param: ResetPasswordRequest) {
    self.service.resetPassword(param).subscribe(onNext: { result in
      if result {
        self.resetPasswordSuccess.onNext(())
      } else {
        print("fail")
      }
    }).disposed(by: disposeBag)
  }
}

