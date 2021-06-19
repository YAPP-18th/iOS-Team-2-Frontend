//
//  MapSearchViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/19.
//

import UIKit
import RxSwift
import RxCocoa

class MapSearchViewController: ViewController {
  let navView = MapSearchNavigationView().then {
    $0.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width)
      $0.height.equalTo(44)
    }
  }
  
  private let listContainer = UIView().then {
    $0.backgroundColor = .systemGray00
  }
  private let searchHistoryView = PostSearchHistoryView()
  private let searchResultView = PostSearchResultView()
  
  private let mapButton = UIButton().then {
    $0.setImage(UIImage(named: "icMapBtnMap"), for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configuration() {
    super.configuration()
    self.navigationItem.titleView = navView
    self.navigationItem.hidesBackButton = true
  }
  
  override func setupView() {
    super.setupView()
    view.addSubview(listContainer)
    listContainer.addSubview(searchHistoryView)
    listContainer.addSubview(searchResultView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    listContainer.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    searchHistoryView.snp.makeConstraints {
      $0.edges.equalTo(listContainer)
    }
    
    searchResultView.snp.makeConstraints {
      $0.edges.equalTo(listContainer)
    }
  }
}
