//
//  Post.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/27.
//

import Foundation

class PostData {
  static let shared = PostData()
  var containers: [PostContainer]?
  var postImages: [Data]?
  var reviewBadge: String?
  var placeName: String?
  var placeLocation: String?
  private init() {}

}

struct PostContainer {
  let container: ContainerSize
  let containerCount: Int
  let food: String
  let foodCount: Int
}

struct ContainerSize {
  let name: String
  let size: String
}
