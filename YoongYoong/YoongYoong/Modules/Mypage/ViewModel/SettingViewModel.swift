//
//  SettingViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/12.
//

import Foundation
import Moya

class SettingViewModel : ViewModel, ViewModelType {
  private let service = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))

  struct Input {
    
  }
  struct Output {
    
  }
  func transform(input: Input) -> Output {
    weak var `self` = self
    let logout = self?.service
    return .init()
  }
}
