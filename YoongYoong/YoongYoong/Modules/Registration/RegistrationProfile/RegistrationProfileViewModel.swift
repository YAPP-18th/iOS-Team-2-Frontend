//
//  RegistrationProfileViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationProfileViewModel : ViewModel, ViewModelType {
  struct Input {
    let nicknameChanged: Observable<String>
    let introduceChanged: Observable<String>
  }
  struct Output {
    let nicknameLength: Driver<String>
    let introduceLength: Driver<String>
  }
  func transform(input: Input) -> Output {
    let nicknameLength = input.nicknameChanged.filter { !$0.isEmpty }.map { "\($0.count)" }.asDriver(onErrorJustReturn: "0")
    let introduceLength = input.introduceChanged.filter { !$0.isEmpty }.map { "\($0.count)" }.asDriver(onErrorJustReturn: "0")
    return .init(
      nicknameLength: nicknameLength,
      introduceLength: introduceLength
    )
  }
}
