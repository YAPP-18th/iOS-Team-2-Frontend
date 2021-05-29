//
//  Date+Extensions.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/29.
//

import Foundation
enum DateFormat: String {
  case yyyyMMdd = "yyyy-MM-dd"
  case month = "M"
}
extension String{
  var asDate : Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
    return dateFormatter.date(from: self)
  }
}
extension Date {
  var asString : String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
    return dateFormatter.string(from: self)
  }
  var month : String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormat.month.rawValue
    return dateFormatter.string(from: self)
  }
}
