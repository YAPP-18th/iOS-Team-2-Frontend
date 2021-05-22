//
//  TermViewControlelr.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/15.
//

import Foundation
import UIKit

class TermViewControlelr : ViewController {
  var tag : Int = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    switch tag {
    case 0:
      setupSimpleNavigationItem(title: "서비스 이용 약관")
    case 1:
      setupSimpleNavigationItem(title: "개인정보 처리방침")
    case 2:
      setupSimpleNavigationItem(title: "위치 기반 서비스")
    case 3:
      setupSimpleNavigationItem(title: "마케팅 정보 수신 동의")
    default:
      setupSimpleNavigationItem(title: "서비스 이용 약관")

    }
  }
}
