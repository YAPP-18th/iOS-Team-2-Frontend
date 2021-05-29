//
//  SplashViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/25.
//

import Foundation
import RxSwift
import RxCocoa

class SplashViewModel : ViewModel, ViewModelType {
  struct Input {
    
  }
  struct Output {
    let login: Observable<LoginViewModel>
    let onboard: Observable<Void>
  }
  
  let splashTrigger = PublishSubject<Void>()
  let loginSubject = PublishSubject<LoginViewModel>()
  let onboard = PublishSubject<Void>()
  
  func transform(input: Input) -> Output {
    splashTrigger.asObservable().map { }.subscribe(onNext: { [weak self] in
      let hasTutorial = UserDefaults.standard.bool(forDefines: .hasTutorial)
      if hasTutorial {
        self?.loginSubject.onNext(LoginViewModel())
      } else {
        self?.onboard.onNext(())
      }
    }).disposed(by: disposeBag)
    
    return .init(
      login: loginSubject.asObservable(),
      onboard: onboard.asObservable()
    )
  }
}
