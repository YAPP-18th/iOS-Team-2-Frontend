//
//  PostSearchViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostSearchViewController: ViewController {
  
  private let imageView = UIImageView().then {
    $0.image = UIImage(named: "postYongyong")
  }
  private let titleLabel = UILabel()
  private let searchBarContainer = UIView()
  private let searchTextField = UITextField()
  private let searchButton = UIButton()
  private let listContainer = UIView()
  private let searchHistoryView = PostSearchHistoryView()
  private let searchResultView = PostSearchResultView()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    guard let viewModel = viewModel as? PostSearchViewModel else { return }

 
    let input = PostSearchViewModel.Input(searchHistoryItemDidTap: searchHistoryView.tableView.rx.itemSelected.asObservable(),
                                          searchResultItemDidTap: searchResultView.tableView.rx.itemSelected.asObservable() ,
                                          removeAllButtonDidTap: searchHistoryView.removeAllButton.rx.tap.asObservable())
    

    let output = viewModel.transform(input: input)

    output.searchHistory
      .bind(to: searchHistoryView.tableView.rx.items(
              cellIdentifier: PostSearchHistoryItemCell.reuseIdentifier,
              cellType: PostSearchHistoryItemCell.self)) { _ , item , cell  in
        cell.textLabel?.text = item
        cell.didDelete = {}
        
      }.disposed(by: disposeBag)
    
    output.searchResult
      .bind(to: searchResultView.tableView.rx.items(cellIdentifier: PostSearchResultItemCell.reuseIdentifier, cellType: PostSearchResultItemCell.self)) { _, _, cell  in
        // TODO: cell 설정
        
      }.disposed(by: disposeBag)
    
    output.postMapView
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { viewModel in
        
        self.navigator.show(segue: .postMap(viewModel: viewModel), sender: self, transition: .navigation())
      }).disposed(by: disposeBag)
    
  }
  
  override func setupView() {
    super.setupView()
    view.addSubview(imageView)
    view.addSubview(titleLabel)
    searchBarContainer.addSubview(searchTextField)
    searchBarContainer.addSubview(searchButton)
    view.addSubview(searchBarContainer)
    view.addSubview(listContainer)
    listContainer.addSubview(searchHistoryView)
    listContainer.addSubview(searchResultView)

  }
  
  override func setupLayout() {
    super.setupLayout()
    
    imageView.snp.makeConstraints {
      $0.width.height.equalTo(172)
      $0.center.equalTo(view.snp.center)
    }
    
    titleLabel.snp.makeConstraints{ make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
      make.left.equalTo(view.snp.left).offset(16)
    }
    
    searchBarContainer.snp.makeConstraints { make in
      make.width.equalTo(342)
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.height.equalTo(40)
      make.centerX.equalTo(view)
    }
    
    searchTextField.snp.makeConstraints { make in
      make.centerY.equalTo(searchBarContainer)
      make.height.equalTo(searchBarContainer.snp.height).multipliedBy(0.90)
      make.left.equalTo(searchBarContainer.snp.left).offset(15)
      make.right.equalTo(searchButton.snp.left)
    }
    
    searchButton.snp.makeConstraints { make in
      make.height.equalTo(searchTextField.snp.height)
      make.width.equalTo(searchButton.snp.height)
      make.centerY.equalTo(searchBarContainer)
      make.right.equalTo(searchBarContainer).offset(-5)
    }
    
    listContainer.snp.makeConstraints {
      $0.top.equalTo(searchBarContainer.snp.bottom).offset(3)
      $0.bottom.left.right.equalTo(view)
    }
    
    searchHistoryView.snp.makeConstraints {
      $0.edges.equalTo(listContainer)
    }
    
    searchResultView.snp.makeConstraints {
      $0.edges.equalTo(listContainer)
    }
    
  }
  
  override func configuration() {
    super.configuration()

    view.backgroundColor = .white
    
    titleLabel.do {
      $0.text = "어디에서 용기를 냈나요?"
      $0.font = UIFont.sdGhothicNeo(ofSize: 24, weight: .regular)
    }
    
    searchBarContainer.do {
      $0.layer.cornerRadius = 12
      $0.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1).cgColor
      $0.layer.borderWidth = 1
    }
    
    searchTextField.do {
      $0.borderStyle = .none
      $0.delegate = self
      $0.placeholder = "검색어를 입력하세요"
      $0.clearButtonMode = .whileEditing
      $0.font = UIFont.sdGhothicNeo(ofSize: 16, weight: .regular)
    }
    
    searchButton.do {
      $0.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    searchButton.do {
      $0.setImage(#imageLiteral(resourceName: "searchStroked"), for: .normal)
    }
    
    searchHistoryView.do {
      $0.isHidden = true
    }
    searchResultView.do {
      $0.isHidden = true
    }

    searchResultView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    searchHistoryView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
  }
  
  @objc
  private func searchButtonDidTap() {
    // TODO: view -> viewModel
    searchTextField.resignFirstResponder()
    searchResultView.isHidden = false
    searchHistoryView.isHidden = true
  }
  
  @objc
  private func closeButtonDidTap() {
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension PostSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

extension PostSearchViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    imageView.isHidden = true
    searchResultView.isHidden = true
    searchHistoryView.isHidden = false
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    imageView.isHidden = false
    searchResultView.isHidden = true
    searchHistoryView.isHidden = true
  }
}
