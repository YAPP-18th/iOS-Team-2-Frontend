//
//  profileRequest.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/30.
//

import Foundation
struct ModifyProfileParam : Encodable{
  let id : Int
  let introduction: String
  let nickname: String
}
