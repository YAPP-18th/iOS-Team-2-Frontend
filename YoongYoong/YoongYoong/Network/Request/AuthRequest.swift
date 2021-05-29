//
//  AuthRequest.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation

struct LoginRequest: Encodable {
  let email:String
  let password:String
}

struct SignupRequest: Encodable {
  let email:String
  let introduction: String
  let loaction: Bool
  let marketing: Bool
  let nickname: String
  let password: String
  let privacy: Bool
  let service :Bool
}

struct CheckEmailDuplicateRequest: Encodable {
    let email: String
}

struct VerifyRequest: Encodable {
    let division: String
    let type: String
    let value: String
}

struct VerifyConfirmRequest: Encodable {
    let codeToken: String
    let code: String
}

