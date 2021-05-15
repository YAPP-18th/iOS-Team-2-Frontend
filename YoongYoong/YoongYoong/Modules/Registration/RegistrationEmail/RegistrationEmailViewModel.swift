//
//  RegistrationEmailViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationEmailViewModel : ViewModel, ViewModelType {
  struct Input {
    let next: Observable<Void>
  }
  struct Output {
    let registrationPassword: Driver<RegistrationPasswordViewModel>
  }
  func transform(input: Input) -> Output {
    let registrationPassword = input.next.asDriver(onErrorJustReturn: ()).map { () -> RegistrationPasswordViewModel in
      let viewModel = RegistrationPasswordViewModel()
      return viewModel
    }
    return .init(
      registrationPassword: registrationPassword
    )
  }
}
