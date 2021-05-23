//
//  String+Extensions.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
import UIKit
extension String {
  
  var packageType : String {
    switch self {
    case "자주 쓰이는 용기":
      return "packagefavorate"
    case "밀폐용기":
      return "packageLock"
    case "냄비":
      return "packagePot"
    case "텀블러":
      return ""
    case "보온 도시락":
      return ""
    default:
      return ""
    }
  }
  
  func convertDistance() -> String {
    guard self.count >= 4 else { return self+"m"}
    
    let distance = Double(Int(self)!)/1000.0
    
    let formatter = LengthFormatter()
    formatter.numberFormatter.roundingMode = .floor
    formatter.numberFormatter.maximumSignificantDigits = 2
    formatter.numberFormatter.minimumSignificantDigits = 2
    return formatter.string(fromValue: distance, unit: .kilometer)
    
  }
  
}
