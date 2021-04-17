//
//  Application.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import UIKit

final class Application: NSObject {
  static let shared = Application()
  let navigator: Navigator
  
  private override init() {
    navigator = Navigator.shared
    super.init()
  }
  var window: UIWindow?
  
  func presentInitialScreen(in window: UIWindow?) {
    guard let window = window else { return }
    self.window = window
    let viewModel = TabBarViewModel()
    self.navigator.show(segue: .tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
  }
}
