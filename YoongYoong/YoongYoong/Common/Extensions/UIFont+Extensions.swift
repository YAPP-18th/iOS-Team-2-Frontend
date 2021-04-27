//
//  UIFont+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/04.
//

import UIKit

public enum SDGothicNeo {
  case thin
  case ultraLight
  case light
  case regular
  case medium
  case semiBold
  case bold
  
  var name: String {
    switch self {
    case .thin:
      return "AppleSDGothicNeo-Thin"
    case .ultraLight:
      return "AppleSDGothicNeo-UltraLight"
    case .light:
      return "AppleSDGothicNeo-Light"
    case .regular:
      return "AppleSDGothicNeo-Regular"
    case .medium:
      return "AppleSDGothicNeo-Medium"
    case .semiBold:
      return "AppleSDGothicNeo-SemiBold"
    case .bold:
      return "AppleSDGothicNeo-Bold"
    }
  }
}

public enum SFProText {
  case thin
  case ultraLight
  case light
  case regular
  case medium
  case semiBold
  case bold
  case black
  case heavy
  
  var name: String {
    switch self {
    case .thin:
      return "SF Pro Text Thin"
    case .ultraLight:
      return "SF Pro Text Ultralight"
    case .light:
      return "SF Pro Text Light"
    case .regular:
      return "SF Pro Text Regular"
    case .medium:
      return "SF Pro Text Medium"
    case .semiBold:
      return "SF Pro Text Semibold"
    case .bold:
      return "SF Pro Text Bold"
    case .black:
      return "SF Pro Text Black"
    case .heavy:
      return "SF Pro Text Heavy"
    }
  }
}

public protocol CustomFont {
  static func sdGhothicNeo(ofSize fontSize: CGFloat, weight: SDGothicNeo) -> UIFont
  static func sfProText(ofSize fontSize: CGFloat, weight: SFProText) -> UIFont
}

extension UIFont: CustomFont {
  public static func sdGhothicNeo(ofSize fontSize: CGFloat, weight: SDGothicNeo) -> UIFont {
    return UIFont(name: weight.name, size: fontSize)!
  }
  
  public static func sfProText(ofSize fontSize: CGFloat, weight: SFProText) -> UIFont {
    return UIFont(name: weight.name, size: fontSize)!
  }
}

extension UIFont {

  class var krDisplay: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Bold", size: 28.0)!
  }

  class var krHeadline: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Regular", size: 24.0)!
  }

  class var krButton1: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)!
  }

  class var krButton2: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Regular", size: 18.0)!
  }

  class var krBody1: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Regular", size: 17.0)!
  }

  class var krTitle1: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Bold", size: 16.0)!
  }

  class var krTitle2: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)!
  }

  class var krBody2: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Regular", size: 14.0)!
  }

  class var krCaption1: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Bold", size: 12.0)!
  }

  class var krTitle3: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Bold", size: 12.0)!
  }

  class var krCaption2: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Regular", size: 12.0)!
  }

  class var krBody3: UIFont {
    return UIFont(name: "AppleSDGothicNeo-Regular", size: 12.0)!
  }

}
