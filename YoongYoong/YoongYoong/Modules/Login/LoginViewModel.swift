//
//  LogInViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/21.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel : ViewModel, ViewModelType {
  
  struct Input {
    let registration: Observable<Void>
  }
  struct Output {
    let registration: Driver<RegistrationTermsViewModel>
  }
  func transform(input: Input) -> Output {
    let registration = input.registration.asDriver(onErrorJustReturn: ()).map { () -> RegistrationTermsViewModel in
      let viewModel = RegistrationTermsViewModel()
      return viewModel
    }
    return .init(
      registration: registration
    )
  }
}
