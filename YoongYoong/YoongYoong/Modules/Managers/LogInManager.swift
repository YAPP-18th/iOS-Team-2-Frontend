//
//  LogInManager.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation
import UIKit

class LoginManager: NSObject {
    static let shared = LoginManager()
    private let login = "isLogin"
    
    override private init() { }
    func isLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: login)
    }
    func makeLoginStatus(
        accessToken: String
    ) {
        UserDefaultHelper<String>.set(accessToken, forKey: .accessToken)
        
        UserDefaults.standard.set(true, forKey: login)
        UserDefaults.standard.synchronize()
    }
    
    func makeLogoutStatus() {
        UserDefaultHelper<Any>.clearAll()
        UserDefaults.standard.set(false, forKey: login)
        UserDefaults.standard.synchronize()
    }
}
