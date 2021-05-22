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
  case accessToken = "accessToken"
  case userId = "userId"
  case searchHistory = "searchHistory"
}
