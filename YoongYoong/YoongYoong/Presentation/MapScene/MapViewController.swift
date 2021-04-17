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
  
  let myLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "btnMapMyLocation"), for: .normal)
  }
  
  let postButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.setTitle("이 가게 포스트 쓰기", for: .normal)
    $0.backgroundColor = .brandPrimary
  }
  
  let storeInfoView = MapStoreInfoView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configuration()
    setupView()
    setupLayout()
    bind()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel as? MapViewModel else { return }
    let input = MapViewModel.Input(tipSelection: navView.tipButton.rx.tap.asObservable())
    let output = viewModel.transform(input: input)
    
    output.tipSelection.drive(onNext: { [weak self] viewModel in
      self?.navigator.show(segue: .tip(viewModel: viewModel), sender: self, transition: .navigation())
    }).disposed(by: disposeBag)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    postButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    postButton.layer.cornerRadius = 16.0
  }
}

extension MapViewController {
  private func configuration() {
    self.view.backgroundColor = .white
    self.navigationItem.titleView = navView
    mapView = NMFMapView()
    mapView.allowsRotating = false
    mapView.allowsTilting = false
    mapView.addCameraDelegate(delegate: self)
    mapView.touchDelegate = self
  }
  
  private func setupView() {
    self.view.addSubview(self.mapView)
    self.view.addSubview(myLocationButton)
    self.view.addSubview(postButton)
    self.view.addSubview(storeInfoView)
  }
  
  private func setupLayout() {
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    myLocationButton.snp.makeConstraints {
      $0.trailing.equalTo(-19)
      $0.bottom.equalTo(storeInfoView.snp.top).offset(-16)
      $0.width.height.equalTo(48)
    }
    
    postButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(56)
    }
    
    storeInfoView.snp.makeConstraints {
      $0.leading.equalTo(29)
      $0.trailing.equalTo(-29)
      $0.bottom.equalTo(postButton.snp.top).offset(-16)
    }
  }
  
  private func bind() {
    self.myLocationButton.rx.tap.bind {
      //Todo1: 위치 권한 체크
      //Todo2: 지도 현재 위치로 이동 및 indicator출력
    }.disposed(by: disposeBag)
    
    self.postButton.rx.tap.bind {
      //Todo1: 포스트 작성 UI 호출
    }.disposed(by: disposeBag)
  }
  
  private func updateView() {
    
  }
  
  // MARK: - Private
  private func didTap(_ marker: NMFMarker) {
    //Todo: 마커 터치시 수행할 작업 ex) 핀 활성화 및 매장 선택
  }
}

extension MapViewController: NMFMapViewTouchDelegate {
  
  
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    //Todo: 맵 터치시 수행할 작업 ex) 핀 비활성화 및 매장 선택 취소
  }
}

extension MapViewController: NMFMapViewCameraDelegate {
  func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    //Todo: 맵 카메라 이동 완료시 수행할 작업 ex) 현위치 기준 핀 새로고침 등
  }
}
