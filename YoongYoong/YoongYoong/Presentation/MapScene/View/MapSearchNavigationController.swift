//
//  MapSearchNavigationController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/05.
//

import UIKit

class MapSearchNavigationController: UINavigationController {
  let navigationView = MapNavigationView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
  }
  
  func setupNavigationBar() {
    self.view.addSubview(navigationView)
    navigationView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.bottom.equalTo(self.navigationBar)
    }
    self.view.bringSubviewToFront(navigationView)
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
  }
}
