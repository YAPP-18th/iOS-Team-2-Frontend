//
//  TipDetailViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/07.
//

import UIKit

class TipDetailViewController: ViewController {
  
  let dimmView = UIView().then {
    $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
  }
  let tipView = TipDetailThirdView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configuration() {
    super.configuration()
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(dimmView)
    self.view.addSubview(tipView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    dimmView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    tipView.snp.makeConstraints {
      $0.top.equalTo(56)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}
