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
    let next: Observable<Void>
  }
  struct Output {
    let registrationProfile: Driver<RegistrationProfileViewModel>
  }
  func transform(input: Input) -> Output {
    let registrationProfile = input.next.asDriver(onErrorJustReturn: ()).map { () -> RegistrationProfileViewModel in
      let viewModel = RegistrationProfileViewModel()
      return viewModel
    }
    return .init(
      registrationProfile: registrationProfile
    )
  }
}
