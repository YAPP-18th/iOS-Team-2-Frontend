//
//  MapViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/05.
//

import UIKit
import NMapsMap
import SnapKit

class MapViewController: UIViewController {
  
  var mapView: NMFMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configuration()
    setupView()
    setupLayout()
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
  }
  
  private func setupLayout() {
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
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
