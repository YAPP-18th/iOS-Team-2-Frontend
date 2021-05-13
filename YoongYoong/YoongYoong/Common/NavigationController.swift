//
//  NavigationController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import UIKit

class NavigationController: UINavigationController{
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    interactivePopGestureRecognizer?.delegate = nil
    
    navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.brandColorGreen01,
      NSAttributedString.Key.font: UIFont.krTitle2
    ]
    
    navigationBar.isTranslucent = false
    navigationBar.barTintColor = .white
    navigationBar.tintColor = .brandColorGreen01
  }
}
