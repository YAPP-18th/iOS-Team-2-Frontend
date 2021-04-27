//
//  Feed.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import Foundation

struct Feed {
  static let dummyList:[Feed] = [
    .init(
      nickname: "김용기",
      profileImageURL: "",
      storeName: "김밥천국 문정점",
      date: "2021-04-24",
      contentImageURL: "",
      menuList: [
        .init(title: "김밥 2", content: "밀폐용기 S"),
        .init(title: "떡볶이", content: "보온도시락 M")
      ]),
    .init(
      nickname: "김나요",
      profileImageURL: "",
      storeName: "홍익돈까스 홍대점",
      date: "2021-04-30",
      contentImageURL: "",
      menuList: [
        .init(title: "돈까스 1", content: "밀폐용기 L"),
        .init(title: "로제파스타", content: "보온도시락 M")
      ]),
    .init(
      nickname: "용용",
      profileImageURL: "",
      storeName: "육개본가",
      date: "2021-04-30",
      contentImageURL: "",
      menuList: [
        .init(title: "차돌 육개장 1", content: "밀폐용기 M")
      ])
  ]
  
  var nickname: String?
  var profileImageURL: String?
  var storeName: String?
  var date: String?
  var contentImageURL: String?
  var menuList: [TitleContentItem]?
}
