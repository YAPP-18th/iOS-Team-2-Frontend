//
//  MapSearchResultViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/25.
//

import UIKit
import RxCocoa
import RxSwift
import NMapsMap

class MapSearchResultViewController: ViewController {
  private let storeInfoView = MapStoreInfoView()
  private let myLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "btnMapMyLocation"), for: .normal)
  }
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
    guard let viewModel = self.viewModel as? MapSearchResultViewModel else { return }
    
    let input = MapSearchResultViewModel.Input()
    let output = viewModel.transform(input: input)
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
  }
  
  override func configuration() {
    super.configuration()
    let gesture = UITapGestureRecognizer(target: self, action: #selector(goToStore))
    self.storeInfoView.addGestureRecognizer(gesture)
    self.storeInfoView.isUserInteractionEnabled = true
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(mapView)
    self.view.addSubview(myLocationButton)
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
    
    storeInfoView.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-32)
    }
  }
  
  @objc func goToStore() {
    guard let place = (self.viewModel as? MapSearchResultViewModel)?.place else { return }
    let viewModel = StoreViewModel(place: place)
    self.navigator.show(segue: .store(viewModel: viewModel), sender: self, transition: .navigation(.right, animated: true, hidesTabbar: true))
  }
}
