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

class MapViewController: UIViewController {
  let disposeBag = DisposeBag()
  
  var mapView: NMFMapView!
  
  let myLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "btnMapMyLocation"), for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configuration()
    setupView()
    setupLayout()
    bind()
  }
}

extension MapViewController {
  private func configuration() {
    self.view.backgroundColor = .white
    mapView = NMFMapView()
    mapView.allowsRotating = false
    mapView.allowsTilting = false
    mapView.addCameraDelegate(delegate: self)
    mapView.touchDelegate = self
  }
  
  private func setupView() {
    
    self.view.addSubview(self.mapView)
    self.view.addSubview(myLocationButton)
  }
  
  private func setupLayout() {
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    myLocationButton.snp.makeConstraints {
      $0.trailing.equalTo(-19)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
      $0.width.height.equalTo(48)
    }
  }
  
  private func bind() {
    self.myLocationButton.rx.tap.bind {
      //Todo1: 위치 권한 체크
      //Todo2: 지도 현재 위치로 이동 및 indicator출력
    }.disposed(by: disposeBag)
  }
  
  private func updateView() {
    
  }
}

extension MapViewController: NMFMapViewTouchDelegate {
  private func didTap(_ marker: NMFMarker) {
    //Todo: 마커 터치시 수행할 작업 ex) 핀 활성화 및 매장 선택
  }
  
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    //Todo: 맵 터치시 수행할 작업 ex) 핀 비활성화 및 매장 선택 취소
  }
}

extension MapViewController: NMFMapViewCameraDelegate {
  func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    //Todo: 맵 카메라 이동 완료시 수행할 작업 ex) 현위치 기준 핀 새로고침 등
  }
}
