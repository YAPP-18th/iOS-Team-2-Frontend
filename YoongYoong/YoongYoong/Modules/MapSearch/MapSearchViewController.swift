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
  private let imageView = UIImageView().then {
    $0.image = UIImage(named: "postYongyong")
  }
  
  private let searchHistoryView = PostSearchHistoryView()
  private let searchResultView = PostSearchResultView()
  
  private let mapButton = UIButton().then {
    $0.setImage(UIImage(named: "icMapBtnMap"), for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? MapSearchViewModel else { return }
    
    let searchText = PublishSubject<String>()
    navView.searchButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        guard let text = self.navView.searchField.text, text.count
                > 0 else { return }
        searchText.onNext(text)
        self.searchButtonDidTap()
      }).disposed(by: disposeBag)
    
    let input = MapSearchViewModel.Input(
      searchTextFieldDidBeginEditing: navView.searchField.rx.controlEvent(.editingDidBegin).asObservable(),
      searchButtonDidTap: searchText,
      removeSearchHistoryItem: PublishSubject<Int>()
    )
    let output = viewModel.transform(input: input)
    
    output.searchHistory
      .bind(to: searchHistoryView.tableView.rx.items(
              cellIdentifier: PostSearchHistoryItemCell.reuseIdentifier,
              cellType: PostSearchHistoryItemCell.self)) { [weak self] index , item , cell  in
        guard let self = self else { return }
        cell.textLabel?.text = item
        cell.binding()
        cell.deleteCell
          .map{ index }
          .bind(to: input.removeSearchHistoryItem)
          .disposed(by: self.disposeBag)
      }.disposed(by: disposeBag)
    
    self.navView.backButton.rx.tap.subscribe {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  override func configuration() {
    super.configuration()
    self.navigationItem.titleView = navView
    self.navigationItem.hidesBackButton = true
  }
  
  override func setupView() {
    super.setupView()
    view.addSubview(imageView)
    view.addSubview(searchHistoryView)
    view.addSubview(searchResultView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    imageView.snp.makeConstraints {
      $0.width.height.equalTo(172)
      $0.center.equalToSuperview()
    }
    
    searchHistoryView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    searchResultView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
//    searchHistoryView.isHidden = true
    searchResultView.isHidden = true
    mapButton.isHidden = true
  }
  private func searchButtonDidTap() {
    navView.searchField.resignFirstResponder()
    searchResultView.isHidden = false
    searchHistoryView.isHidden = true
    mapButton.isHidden = false
  }
  
}
