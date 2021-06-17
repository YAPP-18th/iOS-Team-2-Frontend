//
//  UserDefaultStorage.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation

class UserDefaultStorage {
  static var accessToken: String? {
    return UserDefaultHelper<String>.value(forKey: .accessToken)
  }
  static var userId: Int? {
    return UserDefaultHelper<Int>.value(forKey: .userId)
  }
  static var searchHistory: [String]? {
    return UserDefaultHelper<[String]>.value(forKey: .searchHistory)
  }
  static var myContainers:[String]? {
    return UserDefaultHelper<[String]>.value(forKey: .container)
  }
  static var myContainerSection: ContainerSection? {
    if let temp = UserDefaultHelper<[String]>.value(forKey: .container) {
      let splited = temp.map{$0.split(separator: "/").map{String($0)}}
      var sections = [ContainerCellModel]()
      for item in splited {
        sections.append(ContainerCellModel.init(identity: item[0] + "/" + item[1], title: item[0], size: item[1], isFavorite: true))
      }
      return ContainerSection(id: 0, items: sections)
    }
    else{
       return nil
    }
  }
}

class UserDefaultHelper<T> {
  class func value(forKey key: DataKeys) -> T? {
    if let data = UserDefaults.standard.value(forKey : key.rawValue) as? T {
      return data
    }
    else {
      return nil
    }
  }
  class func value(forkey key: DataKeys) -> [T]? {
    if let data = UserDefaults.standard.array(forKey: key.rawValue) as? [T]? {
      return data
    }
    else {
      return nil
    }
  }
  class func set(_ value: T, forKey key: DataKeys) {
    UserDefaults.standard.set(value, forKey : key.rawValue)
  }
  class func clearAll() {
    UserDefaults.standard.dictionaryRepresentation().keys.forEach { key in
      UserDefaults.standard.removeObject(forKey: key.description)
    }
  }
}

enum DataKeys: String {
  case loginStatus = "loginStatus"
  case accessToken = "accessToken"
  case userId = "userId"
  case searchHistory = "searchHistory"
  case container = "container"
}
