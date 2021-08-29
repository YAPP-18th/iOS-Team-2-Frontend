//
//  JWT.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/08/28.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation

/**
 *  Protocol that defines what a decoded JWT token should be.
 */
protocol JWT {
  /// token header part contents
  var header: [String: Any] { get }
  /// token body part values or token claims
  var body: [String: Any] { get }
  /// token signature part
  var signature: String? { get }
  /// jwt string value
  var string: String { get }
  
  /// value of `exp` claim if available
  var expiresAt: Date? { get }
  /// value of `iss` claim if available
  var issuer: String? { get }
  /// value of `sub` claim if available
  var subject: String? { get }
  /// value of `aud` claim if available
  var audience: [String]? { get }
  /// value of `iat` claim if available
  var issuedAt: Date? { get }
  /// value of `nbf` claim if available
  var notBefore: Date? { get }
  /// value of `jti` claim if available
  var identifier: String? { get }
  /// value of `auth` claim if available
  var role: LoginManager.LoginStatus { get }
  
  /// Checks if the token is currently expired using the `exp` claim. If there is no claim present it will deem the token not expired
  var expired: Bool { get }
}

extension JWT {
  
  /**
   Return a claim by it's name
   - parameter name: name of the claim in the JWT
   - returns: a claim of the JWT
   */
  func claim(name: String) -> Claim {
    let value = self.body[name]
    return Claim(value: value)
  }
}

func decode(jwt: String) throws -> JWT {
  return try DecodedJWT(jwt: jwt)
}

struct DecodedJWT: JWT {
  
  let header: [String: Any]
  let body: [String: Any]
  let signature: String?
  let string: String
  
  init(jwt: String) throws {
    let parts = jwt.components(separatedBy: ".")
    guard parts.count == 3 else {
      throw NSError(domain: "invalidPartCount", code: 0, userInfo: nil)
    }
    
    self.header = try decodeJWTPart(parts[0])
    self.body = try decodeJWTPart(parts[1])
    self.signature = parts[2]
    self.string = jwt
  }
  
  var expiresAt: Date? { return claim(name: "exp").date }
  var issuer: String? { return claim(name: "iss").string }
  var subject: String? { return claim(name: "sub").string }
  var audience: [String]? { return claim(name: "aud").array }
  var issuedAt: Date? { return claim(name: "iat").date }
  var notBefore: Date? { return claim(name: "nbf").date }
  var identifier: String? { return claim(name: "jti").string }
  var role: LoginManager.LoginStatus { return claim(name: "auth").role ?? .none }
    
  var expired: Bool {
    guard let date = self.expiresAt else {
      return false
    }
    return date.compare(Date()) != ComparisonResult.orderedDescending
  }
}

/**
 *  JWT Claim
 */
struct Claim {
  
  /// raw value of the claim
  let value: Any?
  
  /// original claim value
  var rawValue: Any? {
    return self.value
  }
  
  /// value of the claim as `String`
  var string: String? {
    return self.value as? String
  }
  
  /// value of the claim as `Bool`
  var boolean: Bool? {
    return self.value as? Bool
  }
  
  /// value of the claim as `Double`
  var double: Double? {
    var double: Double?
    if let string = self.string {
      double = Double(string)
    } else if self.boolean == nil {
      double = self.value as? Double
    }
    return double
  }
  
  /// value of the claim as `Int`
  var integer: Int? {
    var integer: Int?
    if let string = self.string {
      integer = Int(string)
    } else if let double = self.double {
      integer = Int(double)
    } else if self.boolean == nil {
      integer = self.value as? Int
    }
    return integer
  }
  
  /// value of the claim as `NSDate`
  var date: Date? {
    guard let timestamp: TimeInterval = self.double else { return nil }
    return Date(timeIntervalSince1970: timestamp)
  }
  
  /// value of the claim as `[String]`
  var array: [String]? {
    if let array = self.value as? [String] {
      return array
    }
    if let value = self.string {
      return [value]
    }
    return nil
  }
  
  var role: LoginManager.LoginStatus? {
    var role: LoginManager.LoginStatus?
    if let string = self.string {
      role = .init(rawValue: string)
    }
    return role
  }
}

private func base64UrlDecode(_ value: String) -> Data? {
  var base64 = value
    .replacingOccurrences(of: "-", with: "+")
    .replacingOccurrences(of: "_", with: "/")
  let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
  let requiredLength = 4 * ceil(length / 4.0)
  let paddingLength = requiredLength - length
  if paddingLength > 0 {
    let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
    base64 += padding
  }
  return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
}

private func decodeJWTPart(_ value: String) throws -> [String: Any] {
  guard let bodyData = base64UrlDecode(value) else {
    throw NSError(domain: "invalidBase64URL", code: 1, userInfo: nil)
  }
  
  guard let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
    throw NSError(domain: "invalidJSOn", code: 2, userInfo: nil)
  }
  
  return payload
}
