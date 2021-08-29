//
//  MapViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/05.
//

import UIKit
import NMapsMap
import SnapKit
import RxSwift
import RxCocoa

class MapViewController: ViewController {
  
  let navView = MapNavigationView().then {
    $0.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width)
      $0.height.equalTo(44)
    }
  }
  var mapView: NMFMapView!
  
  var vStackView = UIStackView().then {
    $0.axis = .vertical
  }
  
  let listButton = UIButton().then {
    $0.setImage(UIImage(named:"icMapBtnMenu"), for: .normal)
    $0.layer.cornerRadius = 15
    $0.layer.shadowColor = UIColor.gray.cgColor
    $0.layer.shadowOpacity = 0.5
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowRadius = 6
  }
  
  let myLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "btnMapMyLocation"), for: .normal)
    $0.layer.cornerRadius = 15
    $0.layer.shadowColor = UIColor.gray.cgColor
    $0.layer.shadowOpacity = 0.5
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowRadius = 6
  }
  
  let storeInfoView = MapStoreInfoView()
  
  var myLocationButtonBottomToSuperview: Constraint?
  var myLocationButtonBottomToStoreInfo: Constraint?
  
  
  var markers: [NMFMarker] = []
  var selectedMarker: NMFMarker?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    (self.viewModel as? MapViewModel)?.myLocation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    (self.viewModel as? MapViewModel)?.updatePin()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    guard let viewModel = viewModel as? MapViewModel else { return }
    let input = MapViewModel.Input(
      tip: navView.tipButton.rx.tap.asObservable(),
      myLocation: myLocationButton.rx.tap.asObservable(),
      search: Observable.merge(navView.searchButton.rx.tap.asObservable(), navView.searchFieldButton.rx.tap.asObservable(), listButton.rx.tap.asObservable())
    )
    let output = viewModel.transform(input: input)
    
    output.tip.drive(onNext: { [weak self] viewModel in
      self?.navigator.show(segue: .tip(viewModel: viewModel), sender: self, transition: .navigation(.left))
    }).disposed(by: disposeBag)
    
    output.location.drive (onNext: { [weak self] location in
      guard let self = self else { return }
      let position = NMFCameraPosition(
        .init(lat: location.latitude, lng: location.longitude),
        zoom: 16.0
      )
      self.mapView.moveCamera(.init(position: position))
    }).disposed(by: disposeBag)
    
    output.setting.subscribe(onNext: { [weak self] in
      self?.alertSetting()
    }).disposed(by: disposeBag)
    
    output.appSetting.subscribe(onNext: { [weak self] in
      self?.alertAppSetting()
    }).disposed(by: disposeBag)
    
    output.search.drive(onNext: { [weak self] viewModel in
      self?.navigator.show(segue: .mapSearch(viewModel: viewModel), sender: self, transition: .navigation(animated: false))
    }).disposed(by: disposeBag)
    
    output.pin.drive(onNext: {[weak self] list in
      self?.addMarker(list: list)
    }).disposed(by: disposeBag)
    
  }
  
  // MARK: - Setup Views and Layout
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .white
    self.navigationItem.titleView = navView
    self.navigationItem.hidesBackButton = true
    mapView = NMFMapView()
    mapView.allowsRotating = false
    mapView.allowsTilting = false
    mapView.addCameraDelegate(delegate: self)
    mapView.touchDelegate = self
    
    listButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(self.mapView)
    self.view.addSubview(listButton)
    self.view.addSubview(storeInfoView)
    self.view.addSubview(myLocationButton)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    listButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
      $0.trailing.equalTo(-16)
      $0.width.height.equalTo(48)
    }
    
    storeInfoView.snp.makeConstraints {
      $0.leading.equalTo(29)
      $0.trailing.equalTo(-29)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
    }
    
    myLocationButton.snp.makeConstraints {
      $0.trailing.equalTo(-19)
      myLocationButtonBottomToStoreInfo = $0.bottom.equalTo(storeInfoView.snp.top).offset(-16).constraint
      myLocationButtonBottomToSuperview = $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16).constraint
      $0.width.height.equalTo(48)
    }
    
    myLocationButtonBottomToSuperview?.isActive = true
    myLocationButtonBottomToStoreInfo?.isActive = false
    
    storeInfoView.isHidden = true
  }
  
  private func updateView() {
    
  }
  
  private func alertSetting() {
    let alertController = UIAlertController(title: "알림", message: "위치 정보 확인을 위해 설정에서 위치 권한을 허용해주세요.", preferredStyle: .alert)
    alertController.addAction(.init(title: "권한설정", style: .default, handler: { _ in
      guard let url = URL(string: "App-prefs:root=Privacy&path=LOCATION") else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }))
    alertController.addAction(.init(title: "취소", style: .cancel))
    self.present(alertController, animated: true)
  }
  
  private func alertAppSetting() {
    let alertController = UIAlertController(title: "알림", message: "위치 정보 확인을 위해 설정에서 위치 권한을 허용해주세요.", preferredStyle: .alert)
    alertController.addAction(.init(title: "권한설정", style: .default, handler: { _ in

      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }))
    alertController.addAction(.init(title: "취소", style: .cancel))
    self.present(alertController, animated: true)
  }
  
  @objc func listButtonTapped() {
    
  }
  
  @objc func mapButtonTapped() {
    
  }
  
  private func resetMarkers() {
    markers.forEach {
      $0.mapView = nil
    }
    markers.removeAll()
  }
  
  private func addMarker(list: [PostResponse]) {
    resetMarkers()
    list.forEach { element in
      let position = NMGLatLng(lat: element.placeLatitude, lng: element.placeLongitude)
      let marker = NMFMarker(position: position, iconImage: NMFOverlayImage(name: "icMapPin_deselected"))
      marker.mapView = self.mapView
      marker.touchHandler = { [weak self] overlay in
        guard let self = self else { return true }
        self.didTap(overlay as! NMFMarker)
        return true
      }
      self.markers.append(marker)
    }

  }
}

extension MapViewController {
  // MARK: - Private
  private func didTap(_ marker: NMFMarker) {
    //Todo: 마커 터치시 수행할 작업 ex) 핀 활성화 및 매장 선택
    let position = marker.position
    self.moveCamera(.init(latitude: position.lat, longitude: position.lng), zoom: false)
    if let selectedMarker = self.selectedMarker {
      if selectedMarker != marker {
        deselectMarker(marker: selectedMarker)
      }
    }

    self.selectMarker(marker: marker)
  }
  
  private func selectMarker(marker: NMFMarker) {
    marker.iconImage = .init(image: UIImage(named: "icMapPin_selected")!)
    selectedMarker = marker
    storeInfoView.isHidden = false
    myLocationButtonBottomToSuperview?.isActive = false
    myLocationButtonBottomToStoreInfo?.isActive = true
    
  }
  
  private func deselectMarker(marker: NMFMarker) {
    storeInfoView.isHidden = true
    marker.iconImage = .init(image: UIImage(named: "icMapPin_deselected")!)
    myLocationButtonBottomToSuperview?.isActive = true
    myLocationButtonBottomToStoreInfo?.isActive = false
  }
  private func moveCamera(_ position: CLLocationCoordinate2D, animated: Bool = true, zoom: Bool = true) {
    let cameraUpdate = zoom ? NMFCameraUpdate(scrollTo: NMGLatLng(lat: position.latitude, lng: position.longitude), zoomTo: 16.0) : NMFCameraUpdate(scrollTo: NMGLatLng(lat: position.latitude, lng: position.longitude))
    if animated {
      cameraUpdate.animation = .easeOut
      cameraUpdate.animationDuration = 1
    }

    mapView.moveCamera(cameraUpdate) { isCanceled in
      
    }
  }
}

extension MapViewController: NMFMapViewTouchDelegate {
  
  
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    if let selectedMarker = self.selectedMarker {
      deselectMarker(marker: selectedMarker)
    }
  }
}

extension MapViewController: NMFMapViewCameraDelegate {
  func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    //Todo: 맵 카메라 이동 완료시 수행할 작업 ex) 현위치 기준 핀 새로고침 등
  }
}
