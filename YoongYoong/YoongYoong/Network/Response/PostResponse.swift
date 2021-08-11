//
//  PostResponse.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/27.
//

import Foundation

struct PostResponse: Decodable, Hashable{
  let commentCount: Int
  let content: String?
  let createdDate: String
  let images: [String]
  var likeCount: Int
  let placeLocation: String
  let placeName: String
  let postContainers: [PostContainerModel]
  let postId: Int
  let reviewBadge: String
  let user: UserInfo
  var isLikePressed: Bool
}
struct UserInfo : Decodable, Hashable {
  let email: String
  let id: Int
  var imageUrl: String?
  let introduction: String?
  let nickname: String
}
struct PostContainerModel : Decodable, Hashable {
  let container: ContainerInfo
  let containerCount: Int
  let food: String
  let foodCount: Int
}
struct ContainerInfo: Decodable, Hashable{
  let name: String
  let size: String
}

extension PostResponse {
  var myPagePostModel : PostSimpleModel {
    return .init(
      feedId: postId,
      profile: .init(imagePath: user.imageUrl, name: user.nickname, message: user.introduction, userId: user.id),
      postedAt: createdDate,
      menus: postContainers.map{MenuModel.init(menutitle: $0.food, menuCount: $0.foodCount)},
      thumbNail: images.first ?? "",
      postDescription: content ?? "")
  }
}
