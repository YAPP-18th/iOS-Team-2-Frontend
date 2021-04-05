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
  }
  
  private func setupView() {
    self.mapView = NMFMapView()
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
