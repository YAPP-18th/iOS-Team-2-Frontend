//
//  AppleRegistration.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/08/11.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation

class AppleRegistration {
  static let shared = AppleRegistration()
  
  var email: String?
  var location: Bool = false
  var marketing: Bool = false
  var nickname: String?
  var privacy: Bool = false
  var service: Bool = false
  var socialId: String?
  
  func toDTO() -> AppleRegistrationDTO {
    .init(
      email: email!,
      location: location,
      marketing: marketing,
      nickname: nickname!,
      privacy: privacy,
      service: service,
      socialId: socialId!
    )
  }
}

struct AppleRegistrationDTO: Encodable {
  var email: String
  var location: Bool
  var marketing: Bool
  var nickname: String
  var privacy: Bool
  var service: Bool
  var socialId: String
}
