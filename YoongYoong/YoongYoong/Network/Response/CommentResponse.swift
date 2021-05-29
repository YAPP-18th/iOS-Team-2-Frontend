//
//  CommentResponse.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/27.
//

import Foundation
struct CommentResponse :Decodable {
  let commentId: Int
  let content: String
  let createdDate: String
  let user: UserInfo
}
