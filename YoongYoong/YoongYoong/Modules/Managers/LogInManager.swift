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
    case logined
    case guest
  }
  
    static let shared = LoginManager()
  var userID: String? {
    return UserDefaultHelper<String>.value(forKey: .userId)
  }
  
  var isLogin: Bool {
    return UserDefaultHelper<String>.value(forKey: .loginStatus) == LoginStatus.logined.rawValue
  }
    override private init() { }
    func makeLoginStatus(
      status: LoginStatus,
        accessToken: String,
      userID: Int = 0
    ) {
      UserDefaultHelper<String>.set(status.rawValue, forKey: .loginStatus)
      UserDefaultHelper<String>.set(accessToken, forKey: .accessToken)
      UserDefaultHelper<Int>.set(userID, forKey: .userId)
    }
    
    func makeLogoutStatus() {
        UserDefaultHelper<Any>.clearAll()
      UserDefaultHelper<String>.set(LoginStatus.none.rawValue, forKey: .loginStatus)
    }
}
