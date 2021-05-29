//
//  PackageModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
struct PostSimpleModel {
  let feedId: Int
  let profile : ProfileModel
  let postedAt: String
  let menus:[MenuModel]
  let thumbNail: String
  let postDescription: String
}
struct MenuModel {
  let menutitle:String
  let menuCount: Int
}
extension MenuModel {
  func toStr() -> String {
    
    return menuCount == 1 ? "\(self.menutitle)" : "\(self.menutitle) \(self.menuCount)"
  }
}
