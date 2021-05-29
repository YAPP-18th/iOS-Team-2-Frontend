//
//  PostRequest.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/25.
//

import Foundation

// MARK: - 게시물 생성하기
struct PostRequestDTO: Encodable {
  var containers: [PostContainerDTO]
  var postImages: [Data]
  var reviewBadge: String
  var placeName: String
  var placeLocation: String
}

struct PostContainerDTO: Encodable {
  let container: ContainerDTO
  let containerCount: Int
  let food: String
  let foodCount: Int
}
struct ContainerDTO: Encodable {
  let name: String
  let size: String
}
