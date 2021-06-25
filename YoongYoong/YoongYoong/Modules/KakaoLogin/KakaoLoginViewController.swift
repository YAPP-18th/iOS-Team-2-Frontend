//
//  KakaoLoginViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/25.
//

import UIKit
import WebKit

class KakaoLoginViewController: ViewController {
  private lazy var webView = WKWebView().then {
    $0.uiDelegate = self
    $0.navigationDelegate = self
    $0.scrollView.contentInsetAdjustmentBehavior = .always
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let url = URL(string: "http://52.78.137.81:8080/oauth2/authorization/kakao") else { return }
    webView.navigationDelegate = self
    webView.load(URLRequest(url: url))
  }
  
  override func configuration() {
    super.configuration()
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(webView)
  }
  
  override func setupLayout() {
    self.webView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}
extension KakaoLoginViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
    webView.evaluateJavaScript("document.body.innerHTML.toString()", completionHandler: { res, error in
          if let fingerprint = res {
            let text = fingerprint as! String
            if let data = text.data(using: .utf8),
               let response = try? JSONDecoder().decode(BaseResponse<LoginResponse>.self, from: data) {
              AlertAction.shared.showAlertView(title: "로그인되었습니다", grantMessage: "확인", denyMessage: "취소")
              let viewModel = TabBarViewModel()
              self.navigator.show(segue: .tabs(viewModel: viewModel), sender: self, transition: .modalFullScreen)
              if let token = response.data?.token{
                LoginManager.shared.makeLoginStatus(status: .logined, accessToken: token)
              }
              
            }
          }
        })
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    decisionHandler(.allow)
    
  }
}
// MARK: - WKUIDelegate

extension KakaoLoginViewController: WKUIDelegate {
  
}
