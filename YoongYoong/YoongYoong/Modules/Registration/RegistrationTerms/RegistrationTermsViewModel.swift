//
//  RegistrationTermsViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationTermsViewModel : ViewModel, ViewModelType {
  struct Input {
    let next: Observable<Void>
  }
  struct Output {
    let registrationEmail: Driver<RegistrationEmailViewModel>
  }
  func transform(input: Input) -> Output {
    let registrationEmail = input.next.asDriver(onErrorJustReturn: ()).map { () -> RegistrationEmailViewModel in
      let viewModel = RegistrationEmailViewModel()
      return viewModel
    }
    return .init(
      registrationEmail: registrationEmail
    )
  }
}
