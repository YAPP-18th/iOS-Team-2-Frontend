//
//  AlertListViewController.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class AlertListViewController : ViewController {
  private let alertListTableView = UITableView().then {
    $0.backgroundColor = .white
    $0.separatorStyle = .none
    $0.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.identifier)
  }
  let emptyView = UIView().then{
    $0.isHidden = true
    $0.backgroundColor = .white
  }
  let emptyCharactor = UIImageView().then{
    $0.image = UIImage(named: "CharacterEmptyView")
  }
  let emptyTitle = UILabel().then{
    $0.text = "아직 알림이 없어요"
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = #colorLiteral(red: 0.5569999814, green: 0.5569999814, blue: 0.5759999752, alpha: 1)
  }
  private let refreshTrigger = PublishSubject<Void>()
  override func setupLayout() {
    
    self.view.add(alertListTableView)
    self.view.add(emptyView)
    alertListTableView.snp.makeConstraints{
      $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }
    emptyView.adds([emptyCharactor,emptyTitle])
    emptyView.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    emptyCharactor.snp.makeConstraints{
      $0.top.equalToSuperview().offset(181)
      $0.centerX.equalToSuperview()
    }
    emptyTitle.snp.makeConstraints{
      $0.top.equalTo(emptyCharactor.snp.bottom).offset(22)
      $0.centerX.equalToSuperview()
    }
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func bindViewModel() {
    guard let viewModel = viewModel as? AlertViewModel else { return }
   
    let selectionTrigger = Observable.zip( alertListTableView.rx.itemSelected,
                                           alertListTableView.rx.modelSelected(AlertModel.self))
    let deleteTrigger = Observable.zip( alertListTableView.rx.itemDeleted,
                                           alertListTableView.rx.modelDeleted(AlertModel.self))
    let input = AlertViewModel.Input(loadView: refreshTrigger,
                                     readAlert: selectionTrigger,
                                     deleteAlert: deleteTrigger)
    let output = viewModel.transform(input: input)
    output.alertUsecase.bind(to: alertListTableView.rx.items(cellIdentifier: AlertTableViewCell.identifier,
                                                             cellType: AlertTableViewCell.self)) { row, data, cell in
      cell.bind(model: data)
    }.disposed(by: disposeBag)
    output.alertUsecase.map{!$0.isEmpty}.bind(to: emptyView.rx.isHidden)
      .disposed(by: disposeBag)
    refreshTrigger.onNext(())
  }
}
//extension AlertListViewController : UITableViewDelegate {
//  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//    if editing
//  }
//}
