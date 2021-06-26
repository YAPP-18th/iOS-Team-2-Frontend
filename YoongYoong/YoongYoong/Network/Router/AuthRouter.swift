//
//  AuthRouter.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation
import Moya

enum AuthRouter {
  case register(param: SignupRequest, image: Data)
  case login(param: LoginRequest)
  case guest
  case emailCheck(param: CheckEmailDuplicateRequest)
  case deleteAccount(id: Int)
  case nickNameCheck(param: String)
  case modifyProfiel(param: ModifyProfileParam)
  case findPassword(param: FindPasswordRequest)
  case findPasswordCode(param: FindPasswordCodeRequest)
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
    case .deleteAccount:
      return "/user/withdrawal"
    case .nickNameCheck:
      return "/user/check/nickname"
    case .modifyProfiel:
      return "/user/profile"
    case .findPassword:
      return "/user/password/email"
    case .findPasswordCode:
      return "/user/password/email"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .register, .login, .guest, .findPasswordCode:
      return .post
    case .emailCheck,
         .nickNameCheck,
         .findPassword:
      return .get
    case .deleteAccount:
      return .delete
    case .modifyProfiel:
      return .put
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case let .register(param, image):
      let multipart = MultipartFormData(provider: .data(image), name: "profileImage", fileName: "profileImage.png", mimeType: "image/png")
      return .uploadCompositeMultipart([multipart], urlParameters: try! param.asParameters())
    case .login(let param):
      return .requestJSONEncodable(param)
    case .guest:
      return .requestPlain
    case .emailCheck(let param):
      return .requestParameters(parameters: try! param.asParameters(), encoding: URLEncoding.default)
    case .deleteAccount(let id):
      return .requestParameters(parameters: try! ["userId" : id].asParameters(), encoding: URLEncoding.default)
    case .nickNameCheck(param: let param):
      return .requestParameters(parameters: try! ["nickname" : param].asParameters(), encoding: URLEncoding.default)
    case .modifyProfiel(param: let param):
      
      return .requestPlain
    case .findPassword(let param):
      return .requestParameters(parameters: try! param.asParameters(), encoding: URLEncoding.default)
    case .findPasswordCode(let param):
      return .requestJSONEncodable(param)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .deleteAccount :
      return ["Content-Type":"application/json",
              "Authorization" : "Bearer \(UserDefaultHelper<String>.value(forKey: .accessToken)!)"]
    default:
      return ["Content-Type":"application/json"]
    }
  }
}
