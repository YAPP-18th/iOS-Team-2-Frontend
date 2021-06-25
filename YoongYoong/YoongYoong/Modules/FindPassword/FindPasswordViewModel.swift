//
//  FindPasswordViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/12.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class FindPasswordViewModel: ViewModel, ViewModelType {
  
  private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  
  struct Input {
    let emailCheck: Observable<String>
    let findPassword: Observable<String>
  }
  struct Output {
    let validEmail: Driver<Bool>
    let findPasswordCode: Observable<FindPasswordCodeViewModel>
  }
  
  let findPasswordCode = PublishSubject<FindPasswordCodeViewModel>()
  
  func transform(input: Input) -> Output {
        
    let validEmail = input.emailCheck
      .flatMapLatest { [weak self] email in
        return self?.validateEmailPattern(text: email) ?? .empty()
      }
    
    input.findPassword.subscribe(onNext: { email in
      let param = FindPasswordRequest(email: email)
      self.findPassword(param: param)
    }).disposed(by: disposeBag)
    return .init(
      validEmail: validEmail.asDriver(onErrorDriveWith: .empty()),
      findPasswordCode: self.findPasswordCode
    )
  }
  
  private func validateEmailPattern(text: String) -> Observable<Bool> {
    return Observable.create { observer in
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

      let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
      let result = emailTest.evaluate(with: text)
      observer.onNext(result)
      return Disposables.create()
    }
    
  }
  
  private func findPassword(param: FindPasswordRequest) {
    self.service.findPassword(param).subscribe(onNext: { result in
      if result {
        let viewModel = FindPasswordCodeViewModel(email: param.email)
        self.findPasswordCode.onNext(viewModel)
      } else {
        print("fail")
      }
    }).disposed(by: disposeBag)
  }
}

