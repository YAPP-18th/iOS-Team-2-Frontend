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
    case .emailCheck:
      return "/users/check/email"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .register,
         .login:
      return .post
    case .emailCheck :
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
      return .uploadCompositeMultipart([multipart], urlParameters: try! param.asDictionary())
    case .login(let param):
      return .requestJSONEncodable(param)
    case .emailCheck(let param):
      return .requestParameters(parameters: try! param.asDictionary(), encoding: URLEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json"]
    }
  }
}
