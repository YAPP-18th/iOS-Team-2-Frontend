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
  
  private let myLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "btnMapMyLocation"), for: .normal)
  }
  
  private let postButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.setTitle("이 가게 포스트 쓰기", for: .normal)
    $0.backgroundColor = .brandColorGreen01
    $0.contentVerticalAlignment = .top
    $0.titleEdgeInsets = UIEdgeInsets(top: 10.0,
                                      left: 0.0,
                                      bottom: 0.0,
                                      right: 0.0)
    
  }
  
  private let storeInfoView = MapStoreInfoView()
  
  private let mapView = NMFMapView().then{
    $0.allowsRotating = false
    $0.allowsTilting = false
    $0.positionMode = .normal
  }
  private let marker = NMFMarker().then {
    $0.iconImage = NMFOverlayImage(name: "icMapPin_selected")
  }
  private var myLocationOverlay: NMFLocationOverlay {
    let overlay = mapView.locationOverlay
    overlay.icon = NMFOverlayImage(name: "userLocationPin")
    return overlay
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    guard let viewModel = viewModel as? PostMapViewModel else { return }
    
    let input = PostMapViewModel.Input(post: postButton.rx.tap.asObservable(),
                                       myLocationButtonDidTap: myLocationButton.rx.tap.asObservable())
    
    let output = viewModel.transform(input: input)
    
    output.imageSelectionView
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] viewModel in
        self?.navigator.show(segue: .selectImage(viewModel: viewModel), sender: self, transition: .navigation())
      }).disposed(by: disposeBag)
    
    output.setting
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.showPermissionAlert()
      }).disposed(by: disposeBag)
    
    output.storeInfo
      .observeOn(MainScheduler.instance)
      .subscribe(onNext:{ [weak self] place in
        let position = NMFCameraPosition(
          .init(lat: place.coordinate.latitude, lng: place.coordinate.longitude),
          zoom: 16.0
        )
        self?.marker.position = NMGLatLng(lat: place.coordinate.latitude,
                                          lng:  place.coordinate.longitude)
        self?.marker.mapView = self?.mapView
        self?.mapView.moveCamera(.init(position: position))
        
        self?.storeInfoView.distanceLabel.text = place.distance.convertDistance()
        self?.storeInfoView.postCountLabel.text = "|   포스트 \(place.reviewCount)개"
        self?.storeInfoView.nameLabel.text = place.name
        self?.storeInfoView.locationLabel.text = place.address
      }).disposed(by: disposeBag)
    
    output.myLocation
      .observeOn(MainScheduler.instance)
      .subscribe(onNext:{ [weak self] location in
        self?.myLocationOverlay.location = NMGLatLng(lat: location.latitude, lng: location.longitude)
      }).disposed(by: disposeBag)
    
    output.myLocation
      .skip(1)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext:{ [weak self] location in
        let position = NMFCameraPosition(.init(lat: location.latitude,
                                               lng: location.longitude),
                                         zoom: 16.0)
        self?.mapView.moveCamera(.init(position: position))
      }).disposed(by: disposeBag)
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
    self.view.addSubview(mapView)
    self.view.addSubview(myLocationButton)
    self.view.addSubview(postButton)
    self.view.addSubview(storeInfoView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    mapView.snp.makeConstraints {
      $0.edges.equalTo(view)
    }
    
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
      $0.leading.trailing.equalToSuperview().inset(19)
      $0.bottom.equalTo(postButton.snp.top).offset(-16)
    }
    
  }
  
  private func showPermissionAlert() {
    let alertController = UIAlertController(title: nil, message: "사진 기능을 사용하려면 '사진' 접근권한을 허용해야 합니다.", preferredStyle: .alert)
    alertController.addAction(.init(title: "설정", style: .default, handler: { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }))
    alertController.addAction(.init(title: "취소", style: .cancel))
    self.present(alertController, animated: true)
  }
  
}


