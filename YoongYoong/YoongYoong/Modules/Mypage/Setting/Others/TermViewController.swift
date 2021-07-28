//
//  TermViewControlelr.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/15.
//

import Foundation
import UIKit
import WebKit

class TermViewControlelr : ViewController {
    var tag : Int = 0
    private var Webkit = WKWebView()
    
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
        self.view.add(Webkit)
        Webkit.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        makeWebViewLoad()
    }
    
    private func makeWebViewLoad() {
        switch tag {
        case 0 :
            Webkit.load(URLRequest(url: Bundle.main.url(forResource: "privacy", withExtension: "html")!))
            
        case 1 :
            Webkit.load(URLRequest(url: Bundle.main.url(forResource: "marketing", withExtension: "html")!))
            
        case 2 :
            Webkit.load(URLRequest(url: Bundle.main.url(forResource: "service", withExtension: "html")!))
            
        case 3 :
            Webkit.load(URLRequest(url: Bundle.main.url(forResource: "location", withExtension: "html")!))
            
        default :
            Webkit.load(URLRequest(url: Bundle.main.url(forResource: "service", withExtension: "html")!))
        }
    }
}
