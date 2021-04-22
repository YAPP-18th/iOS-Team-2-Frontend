//
//  PostMapViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/22.
//

import Foundation
import NMapsMap
import SnapKit
import RxSwift
import RxCocoa

class PostMapViewController: ViewController {
  
  let myLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "btnMapMyLocation"), for: .normal)
  }
  
  let postButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.setTitle("이 가게 포스트 쓰기", for: .normal)
    $0.backgroundColor = .brandPrimary
    $0.contentVerticalAlignment = .top
    $0.titleEdgeInsets = UIEdgeInsets(top: 10.0,
                                      left: 0.0,
                                      bottom: 0.0,
                                      right: 0.0)

  }
  
  let storeInfoView = MapStoreInfoView()

  let mapView = NMFMapView().then{
    $0.allowsRotating = false
    $0.allowsTilting = false
  }
  
  override func loadView() {
    view = mapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func bindViewModel() {
    super.bindViewModel()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    postButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    postButton.layer.cornerRadius = 16.0
  }
  
  // MARK: - Setup Views and Layout
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .white
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(myLocationButton)
    self.view.addSubview(postButton)
    self.view.addSubview(storeInfoView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    myLocationButton.snp.makeConstraints {
      $0.trailing.equalTo(-19)
      $0.bottom.equalTo(storeInfoView.snp.top).offset(-16)
      $0.width.height.equalTo(48)
    }
    
    postButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(88)
    }
    
    storeInfoView.snp.makeConstraints {
      $0.leading.equalTo(29)
      $0.trailing.equalTo(-29)
      $0.bottom.equalTo(postButton.snp.top).offset(-16)
    }
  }
}


