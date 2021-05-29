//
//  PostResponse.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/27.
//

import Foundation
struct PostResponse : Decodable{
    let commentCount: Int
    let createdDate: String
    let images: [String]
    let likeCount: Int
    let placeLocation: String
    let placeName: String
    let postContainers: [PostContainerModel]
    let postId: Int
    let reviewBadge: String
    let user: UserInfo
  }
struct UserInfo : Decodable {
  let email: String
  let id: Int
  let imageUrl: String
  let introduction: String
  let nickname: String
}
struct PostContainerModel : Decodable {
    let container: ContainerInfo
    let containerCount: Int
    let food: String
    let foodCount: Int
}
struct ContainerInfo: Decodable{
  let name: String
  let size: String
}
