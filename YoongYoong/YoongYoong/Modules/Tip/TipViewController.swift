//
//  TipViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class TipViewController: ViewController {
  
  lazy var tableView = UITableView().then {
    $0.contentInset.top = 32
    $0.contentInset.bottom = 32
    $0.backgroundColor = .clear
    $0.separatorStyle = .none
    $0.register(TipTableViewCell.self, forCellReuseIdentifier: TipTableViewCell.identifier)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .white
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(tableView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? TipViewModel else { return }
    let input = TipViewModel.Input()
    let output = viewModel.transform(input: input)
    
    let dataSource = RxTableViewSectionedReloadDataSource<TipSection>(configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: TipTableViewCell.identifier, for: indexPath) as! TipTableViewCell
      cell.bind(to: item)
      return cell
    })
    
    output.items.asObservable()
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    
    self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  
}

extension TipViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 157
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destinationVC = TipDetailViewController(viewModel: nil, navigator: navigator)
    destinationVC.modalPresentationStyle = .overCurrentContext
    destinationVC.modalTransitionStyle = .crossDissolve
    self.present(destinationVC, animated: true, completion: nil)
  }
}
