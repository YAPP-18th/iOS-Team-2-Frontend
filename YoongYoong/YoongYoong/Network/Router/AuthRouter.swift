//
//  AuthRouter.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation
import Moya

enum AuthRouter {
  case register(param: SignupRequest)
  case login(param: LoginRequest)
  case guest
  case emailCheck(param: CheckEmailDuplicateRequest)
}


extension AuthRouter: TargetType {
  public var baseURL: URL {
    return URL(string: "http://52.78.137.81:8080")!
  }
  
  var path: String {
    switch self {
    case .register:
      return "/user/sign-up"
    case .login:
      return "/user/login"
    case .guest:
      return "/user/login/guest"
    case .emailCheck:
      return "/user/check/email"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .register, .login, .guest:
      return .post
    case .emailCheck:
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .register(let param):
      let multipart = MultipartFormData(provider: .data(Data()), name: "profileImage")
      return .uploadCompositeMultipart([multipart], urlParameters: try! param.asParameters())
    case .login(let param):
      return .requestJSONEncodable(param)
    case .guest:
      return .requestPlain
    case .emailCheck(let param):
      return .requestParameters(parameters: try! param.asParameters(), encoding: URLEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json"]
    }
  }
}
