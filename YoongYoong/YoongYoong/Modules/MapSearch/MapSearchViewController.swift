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
  
  private let listContainer = UIView()
  private let searchHistoryView = PostSearchHistoryView()
  private let searchResultView = MapSearchResultView()
  
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
      removeSearchHistoryItem: PublishSubject<Int>(),
      removeAllButtonDidTap: searchHistoryView.removeAllButton.rx.tap.asObservable(),
      searchHistoryItemDidTap: searchHistoryView.tableView.rx.itemSelected.asObservable()
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
    output.searchHistory.bind(onNext: { list in
      self.searchHistoryView.isHidden = list.isEmpty
    }).disposed(by: disposeBag)
    
    output.searchHistorySelected
      .subscribe(onNext: { [weak self] text in
        self?.navView.searchField.text = text
        self?.searchButtonDidTap()
      }).disposed(by: disposeBag)
    
    output.searchResult
      .bind(to: searchResultView.tableView.rx.items(cellIdentifier: PostSearchResultItemCell.reuseIdentifier, cellType: PostSearchResultItemCell.self)) { index, item, cell  in
        cell.setupCellData(item)
      }.disposed(by: disposeBag)
    
    output.searchResult
      .map { $0.isEmpty }
      .subscribe(onNext: { [weak self] in
        self?.searchResultView.tableViewIsEmpty($0)
      }).disposed(by: disposeBag)
    
    self.navView.backButton.rx.tap.subscribe(onNext: {
      self.navigationController?.popViewController(animated: true)
    }).disposed(by: disposeBag)
    
    self.mapButton.rx.tap.subscribe(onNext: {
      self.navigationController?.popViewController(animated: false)
    }).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    self.navigationItem.titleView = navView
    self.navigationItem.hidesBackButton = true
    navView.searchField.delegate = self
  }
  
  override func setupView() {
    super.setupView()
    view.addSubview(listContainer)
    listContainer.addSubview(searchHistoryView)
    listContainer.addSubview(searchResultView)
    listContainer.addSubview(mapButton)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    listContainer.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    searchHistoryView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    searchResultView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    mapButton.snp.makeConstraints {
      $0.top.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.width.height.equalTo(48)
    }
    
    searchResultView.isHidden = true
    mapButton.isHidden = true
  }
  private func searchButtonDidTap() {
    navView.searchField.resignFirstResponder()
    self.searchResultView.isHidden = false
    self.searchHistoryView.isHidden = true
    self.mapButton.isHidden = false
  }
  
}
extension MapSearchViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    searchResultView.isHidden = true
    searchHistoryView.isHidden = false
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    DispatchQueue.main.async {
      self.searchHistoryView.isHidden = true
    }
  }
}
