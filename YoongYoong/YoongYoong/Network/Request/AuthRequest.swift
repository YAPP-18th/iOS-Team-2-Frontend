//
//  AuthRequest.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import UIKit

struct LoginRequest: Encodable {
  let email:String
  let password:String
}

struct SignupRequest: Encodable {
  let email: String
  let password: String
  let nickname: String
  let introduction: String
  let location: Bool
  let service: Bool
  let privacy: Bool
  let marketing: Bool
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

