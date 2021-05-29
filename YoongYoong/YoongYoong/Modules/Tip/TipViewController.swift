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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  override func configuration() {
    super.configuration()
    setupRightBarButton()
  }
  
  func setupRightBarButton() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "icBtnNavForward")?
        .withRenderingMode(.alwaysOriginal),
      style: .plain,
      target: self,
      action: #selector(backToMap)
    )
  }
  
  @objc func backToMap() {
    self.navigator.show(segue: .map(viewModel: .init()), sender: self, transition: .navigation(.right))
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
    if indexPath.row == 0 {
      destinationVC.tipView = TipDetailFirstView()
    } else if indexPath.row == 1 {
      destinationVC.tipView = TipDetailSecondView()
    } else {
      destinationVC.tipView = TipDetailThirdView()
    }
    
    destinationVC.modalPresentationStyle = .overFullScreen
    destinationVC.modalTransitionStyle = .crossDissolve
    self.present(destinationVC, animated: false, completion: nil)
  }
}
