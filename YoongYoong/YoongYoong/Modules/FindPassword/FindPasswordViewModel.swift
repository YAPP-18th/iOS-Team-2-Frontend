//
//  FindPasswordViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class FindPasswordViewModel: ViewModel, ViewModelType {
  
  struct Input {
    let emailCheck: Observable<String>
  }
  struct Output {
    let validEmail: Driver<Bool>
  }
  func transform(input: Input) -> Output {
        
    let validEmail = input.emailCheck
      .flatMapLatest { [weak self] email in
        return self?.validateEmailPattern(text: email) ?? .empty()
      }
    return .init(
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

