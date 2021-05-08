//
//  Tip.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/06.
//

import UIKit

enum Tip: CaseIterable {
  case size
  case info
  case tip
  
  var title: String? {
    switch self {
    case .size:
      return "용기 사이즈 정보"
    case .info:
      return "다회용기 실천 가이드"
    case .tip:
      return "개인 용기 이용 꿀팁"
    }
  }
  
  var subtitle: String? {
    switch self {
    case .size:
      return "가게에 어떤 용기를 들고가면 좋을까?"
    case .info:
      return "용기내용과 함께하는 다회용기 실천 방법은?"
    case .tip:
      return "실천에 도움되는 꿀 정보는?"
    }
  }
  
  var backgroundImage: UIImage? {
    return UIImage(named: "")
  }
  
  var iconImage: UIImage? {
    switch self {
    case .size:
      return UIImage(named: "icTipFirst")
    case .info:
      return UIImage(named: "icTipSecond")
    case .tip:
      return UIImage(named: "icTipThird")
    }
  }
  
}
