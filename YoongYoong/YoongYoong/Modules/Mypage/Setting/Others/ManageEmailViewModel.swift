//
//  ManageEmailViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/09/11.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import RxSwift
import RxCocoa

final class ManageEmailViewModel: ViewModel, ViewModelType {
  struct Input {
    
  }
  
  struct Output {
    let email: Driver<String>
  }
  
  func transform(input: Input) -> Output {
    let email = globalUser.value.email
    return .init(email: .just(email))
  }
}
