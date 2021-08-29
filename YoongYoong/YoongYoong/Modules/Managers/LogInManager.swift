//
//  LogInManager.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation
import UIKit

class LoginManager: NSObject {
  enum LoginStatus: String {
    case none
    case logined = "ROLE_USER"
    case guest = "ROLE_GUEST"
  }
  
  static let shared = LoginManager()
  
  var userID: String? {
    return UserDefaultHelper<String>.value(forKey: .userId)
  }
  
  var loginStatus: LoginStatus {
    get {
      return LoginStatus(rawValue: UserDefaultHelper<String>.value(forKey: .loginStatus) ?? "") ?? .none
    }
    set {
      UserDefaultHelper<String>.set(newValue.rawValue, forKey: .loginStatus)
    }
  }
  
  var accessToken: String? {
    return UserDefaultHelper<String>.value(forKey: .accessToken)
  }
  
  var refreshToken: String? {
    return UserDefaultHelper<String>.value(forKey: .refreshToken)
  }
  
  var tokenExpired: Bool {
    guard let token = UserDefaultHelper<String>.value(forKey: .accessToken) else { return true }
    guard !token.isEmpty else { return true }
    guard let isExpired = try? decode(jwt: token).expired else { return true }
    return isExpired
  }
  
  var refreshTokenExpired: Bool {
    guard let token = UserDefaultHelper<String>.value(forKey: .refreshToken) else { return true }
    guard !token.isEmpty else { return true }
    guard let isExpired = try? decode(jwt: token).expired else { return true }
    return isExpired
  }
  
  var isLogin: Bool {
    return !self.tokenExpired || !refreshTokenExpired
  }
  
    override private init() { }
    func makeLoginStatus(
        accessToken: String,
      refreshToken: String = ""
    ) {
      UserDefaultHelper<String>.set(accessToken, forKey: .accessToken)
      UserDefaultHelper<String>.set(refreshToken, forKey: .refreshToken)
      if let jwtBody = try? decode(jwt: accessToken) {
        UserDefaultHelper<String>.set(jwtBody.role.rawValue, forKey: .loginStatus)
      }
    }
    
    func makeLogoutStatus() {
        UserDefaultHelper<Any>.clearAll()
      UserDefaultHelper<String>.set(LoginStatus.none.rawValue, forKey: .loginStatus)
      UserDefaultHelper<String>.set("", forKey: .accessToken)
      UserDefaultHelper<String>.set("", forKey: .refreshToken)
      UserDefaults.standard.set(true, forDefines: .hasTutorial)
    }
}
