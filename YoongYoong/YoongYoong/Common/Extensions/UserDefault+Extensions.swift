//
//  UserDefault+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/25.
//

import Foundation

enum UserDefaultKey: String {
  case hasTutorial = "USERDEFAULT_KEY_HAS_TUTORIAL"
}

protocol UserDefaultProtocol {
  // MARK: Set
  func set(_ value: Int, forDefines: UserDefaultKey)
  func set(_ value: Float, forDefines: UserDefaultKey)
  func set(_ value: Bool, forDefines: UserDefaultKey)
  func set(_ value: Any?, forDefines: UserDefaultKey)
  func set(_ value: Date, forDefines: UserDefaultKey)
  
  // MARK: Get
  func integer(forDefines: UserDefaultKey) -> Int
  func float(forDefines: UserDefaultKey) -> Float
  func bool(forDefines: UserDefaultKey) -> Bool
  func string(forDefines: UserDefaultKey) -> String?
  func date(forDefines: UserDefaultKey) -> Date?
  
  func removeObject(forDefines: UserDefaultKey)
}
extension UserDefaults: UserDefaultProtocol {
  // MARK: Set
  func set(_ value: Int, forDefines: UserDefaultKey) {
    set(value, forKey: forDefines.rawValue)
    synchronize()
  }

  func set(_ value: Float, forDefines: UserDefaultKey) {
    set(value, forKey: forDefines.rawValue)
    synchronize()
  }

  func set(_ value: Bool, forDefines: UserDefaultKey) {
    set(value, forKey: forDefines.rawValue)
    synchronize()
  }

  func set(_ value: Any?, forDefines: UserDefaultKey) {
    set(value, forKey: forDefines.rawValue)
    synchronize()
  }

  func set(_ value: Date, forDefines: UserDefaultKey) {
    set(value, forKey: forDefines.rawValue)
    synchronize()
  }

  // MARK: Get
  func integer(forDefines: UserDefaultKey) -> Int {
    return integer(forKey: forDefines.rawValue)
  }

  func float(forDefines: UserDefaultKey) -> Float {
    return float(forKey: forDefines.rawValue)
  }

  func bool(forDefines: UserDefaultKey) -> Bool {
    return bool(forKey: forDefines.rawValue)
  }

  func string(forDefines: UserDefaultKey) -> String? {
    return string(forKey: forDefines.rawValue)
  }

  func object(forDefines: UserDefaultKey) -> Any? {
    return object(forKey: forDefines.rawValue)
  }

  func array(forDefines: UserDefaultKey) -> [Any]? {
    return array(forKey: forDefines.rawValue)
  }

  func date(forDefines: UserDefaultKey) -> Date? {
    return value(forKey: forDefines.rawValue) as? Date
  }

  func removeObject(forDefines: UserDefaultKey) {
    self.removeObject(forKey: forDefines.rawValue)
  }
}
