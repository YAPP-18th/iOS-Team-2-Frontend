//
//  PostUsecase.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/03.
//

import Foundation
struct PostListModel {
  let month : String
  let postCount: Int
  let packageCount: Int
  let postList:[PostResponse]
  
  static let sample =  PostListModel(month: "2020년 6월", postCount: 0, packageCount: 0, postList: [])
}

