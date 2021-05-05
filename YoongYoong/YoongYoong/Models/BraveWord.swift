//
//  BraveWord.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/02.
//

import Foundation

struct BraveWord {
  static let `default` = "가볍게 텀블러 사용은 어때용?"
  
  private var isMonday: Bool {
    let component = Calendar.current.component(.weekday, from: Date())
    print(component)
    return component == 2
  }
  
  private var isWeekend: Bool {
    let component = Calendar.current.component(.weekday, from: Date())
    print(component)
    return component == 1 || component == 7
  }
  
  func randomBrave() -> String? {
    guard let path = Bundle.main.path(forResource: "BraveWords", ofType: "plist"),
          let dictRoot = NSDictionary(contentsOfFile: path)
    else { return nil }
    
    if isMonday {
      guard let mondayWord = dictRoot["monday"] as? String else { return nil }
      return mondayWord
    } else if isWeekend {
      guard let weekendWord = dictRoot["weekend"] as? String else { return nil }
      return weekendWord
    } else {
      guard let normalWordList = dictRoot["normal"] as? [String: String] else { return nil }
      let randomIndex = Int(arc4random_uniform(UInt32(normalWordList.values.count)))
      return Array(normalWordList.values)[randomIndex]
    }
  }
}
