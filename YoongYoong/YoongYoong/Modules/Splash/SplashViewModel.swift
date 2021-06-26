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
    let main: Observable<TabBarViewModel>
  }
  
  let splashTrigger = PublishSubject<Void>()
  let loginSubject = PublishSubject<LoginViewModel>()
  let mainSubject = PublishSubject<TabBarViewModel>()
  let onboard = PublishSubject<Void>()
  
  func transform(input: Input) -> Output {
    splashTrigger.asObservable().map { }.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      let hasTutorial = UserDefaults.standard.bool(forDefines: .hasTutorial)
      if !hasTutorial {
        self.onboard.onNext(())
        return
      }
      
      if !LoginManager.shared.isLogin {
        self.loginSubject.onNext(LoginViewModel())
        return
      }
      
      self.mainSubject.onNext(TabBarViewModel())
      
    }).disposed(by: disposeBag)
    
    return .init(
      login: loginSubject.asObservable(),
      onboard: onboard.asObservable(),
      main: mainSubject.asObserver()
    )
  }
}
