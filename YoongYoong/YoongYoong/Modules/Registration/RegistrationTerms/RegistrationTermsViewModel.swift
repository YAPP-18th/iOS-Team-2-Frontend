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
    let next: Observable<Bool>
  }
  struct Output {
    let registrationEmail: Driver<RegistrationEmailViewModel>
  }
  
  var checkedAll = BehaviorRelay<Bool>(value: false)
  
  func transform(input: Input) -> Output {
    let registrationEmail = input.next.asDriver(onErrorJustReturn: false).map { isMarkettingAgree -> RegistrationEmailViewModel in
      let viewModel = RegistrationEmailViewModel(isMarketingAgree: isMarkettingAgree)
      return viewModel
    }
    
    return .init(
      registrationEmail: registrationEmail
    )
  }
}
