//
//  FindPasswordCodeViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/25.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class FindPasswordCodeViewModel: ViewModel, ViewModelType {
  private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  
  let email: String
  
  init(email: String) {
    self.email = email
  }
  struct Input {
    let editingChanged: Observable<String>
    let nextButtonDidTap: Observable<Void>
  }
  
  struct Output {
    let codeSuccess: Observable<FindPasswordInputViewModel>
    let codeFail: Observable<Void>
    let validCode: Driver<Bool>
  }
  
  let code = BehaviorRelay<String>(value: "")
  let validCode = BehaviorRelay<Bool>(value: false)
  let codeSuccess = PublishSubject<FindPasswordInputViewModel>()
  let codeFail = PublishSubject<Void>()
  
  func transform(input: Input) -> Output {
    input.editingChanged.bind(to: code).disposed(by: self.disposeBag)
    
    input.nextButtonDidTap.subscribe(onNext: {
      let code = self.code.value
      let param = FindPasswordCodeRequest(email: self.email, code: code)
      self.checkCode(param: param)
    }).disposed(by: disposeBag)
    
    code.map { !$0.isEmpty }.asObservable().bind(to: validCode).disposed(by: disposeBag)
    
    return .init(
      codeSuccess: self.codeSuccess,
      codeFail: self.codeFail,
      validCode: validCode.asDriver()
    )
  }
  
  private func checkCode(param: FindPasswordCodeRequest) {
    self.service.findPasswordCode(param).subscribe(onNext: { result in
      if result {
        let viewModel = FindPasswordInputViewModel(email: self.email, code: self.code.value)
        self.codeSuccess.onNext(viewModel)
      } else {
        self.codeFail.onNext(())
      }
    }).disposed(by: disposeBag)
  }
}
