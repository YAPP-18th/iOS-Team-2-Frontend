//
//  FindPasswordCodeViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/25.
//

import Foundation
import RxSwift
import RxCocoa

class FindPasswordCodeViewModel: ViewModel, ViewModelType {
  struct Input {
    let editingChanged: Observable<String>
    let nextButtonDidTap: Observable<Void>
  }
  
  struct Output {
    let codeSuccess: Observable<Void>
    let codeFail: Observable<Void>
  }
  
  let code = BehaviorRelay<String>(value: "")
  let codeSuccess = PublishSubject<Void>()
  let codeFail = PublishSubject<Void>()
  
  func transform(input: Input) -> Output {
    input.editingChanged.bind(to: code).disposed(by: self.disposeBag)
    
    input.nextButtonDidTap.subscribe(onNext: {
      let code = self.code.value
      self.checkCode(code)
    }).disposed(by: disposeBag)
    return .init(
      codeSuccess: self.codeSuccess,
      codeFail: self.codeFail
    )
  }
  
  private func checkCode(_ code: String) {
    
  }
}
