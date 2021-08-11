//
//  RegistrationProfileViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class RegistrationProfileViewModel : ViewModel, ViewModelType {
  
  let isAppleRegistration: Bool
  let isMarketingAgree: Bool
  let email: String
  let password: String
  
  private let service : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  
  init(
    isAppleRegistration: Bool = false,
    isMarketingAgree: Bool,
    email: String,
    password: String
  ) {
    self.isAppleRegistration = isAppleRegistration
    self.isMarketingAgree = isMarketingAgree
    self.email = email
    self.password = password
  }
  
  struct Input {
    let nicknameChanged: Observable<String>
    let introduceChanged: Observable<String>
    let register: Observable<(String, String, UIImage)>
  }
  struct Output {
    let defaultNickname: Driver<String?>
    let nicknameLength: Driver<String>
    let introduceLength: Driver<String>
    let checkNicknameResult: Driver<Bool>
    let signUp: Driver<Response>
  }
  
  let signUp = PublishSubject<Response>()
  
  func transform(input: Input) -> Output {
    let result = input.nicknameChanged
      .flatMapLatest{ [weak self] email in
        self?.service.checkEmailDuplicate(.init(email: email)) ?? .empty()
      }
    
   input.register.subscribe(onNext: { [weak self] nickname, introduction, image in
      guard let self = self else { return }
    if self.isAppleRegistration {
      AppleRegistration.shared.nickname = nickname
      let dto = AppleRegistration.shared.toDTO()
      self.service.signup(dto).bind(to: self.signUp).disposed(by: self.disposeBag)
    } else {
      let dto = SignupRequest(
              email: self.email,
              password: self.password,
              nickname: nickname,
              introduction: introduction,
              location: true,
              service: true,
              privacy: true,
              marketing: self.isMarketingAgree
        )
      self.service.signup(dto, image: image.pngData()!).bind(to: self.signUp).disposed(by: self.disposeBag)
    }
    
   }).disposed(by: disposeBag)
    
    let nicknameLength = input.nicknameChanged.filter { !$0.isEmpty }.map { "\($0.count)" }.asDriver(onErrorJustReturn: "0")
    let introduceLength = input.introduceChanged.filter { !$0.isEmpty }.map { "\($0.count)" }.asDriver(onErrorJustReturn: "0")
    return .init(
      defaultNickname: .just(self.isAppleRegistration ? AppleRegistration.shared.nickname : nil),
      nicknameLength: nicknameLength,
      introduceLength: introduceLength,
      checkNicknameResult: result.asDriver(onErrorDriveWith: .empty()),
      signUp: self.signUp.asDriver(onErrorJustReturn: Response.init(statusCode: 400, data: Data()))
    )
  }
}
