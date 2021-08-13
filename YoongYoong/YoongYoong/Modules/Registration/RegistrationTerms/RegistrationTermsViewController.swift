//
//  RegistrationTermsViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RegistrationTermsViewController: ViewController {
  var isCheckedAll: Bool = false
  
  let titleLabel = UILabel().then {
    $0.text = "환영합니다!"
    $0.font = .krTitle1
    $0.textColor = .systemGrayText01
  }
  
  let checkAllButton = UIButton().then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
    $0.adjustsImageWhenHighlighted = false
  }
  
  let checkAllLabel = UILabel().then {
    $0.text = "전체 동의"
    $0.font = .krCaption1
    $0.textColor = .systemGrayText01
  }
  
  let divider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.register(TermsCheckTableViewCell.self, forCellReuseIdentifier: TermsCheckTableViewCell.identifier)
    $0.rowHeight = 40
    $0.bounces = false
  }
  
  lazy var dataSource = RxTableViewSectionedReloadDataSource<TermsCheckSection> { dataSource, tableView, indexPath, item in
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsCheckTableViewCell.identifier, for: indexPath) as? TermsCheckTableViewCell else { return .init() }
    cell.bind(to: item)
    cell.detailButton.rx.tap.subscribe(onNext: {
      let vc = TermViewControlelr(viewModel: nil, navigator: self.navigator)
      vc.tag = indexPath.row
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: self.disposeBag)
    return cell
  }
  
  let nextButton = Button().then {
    $0.setTitle("다음", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? RegistrationTermsViewModel else { return }
    let input = RegistrationTermsViewModel.Input(
      checkAll: checkAllButton.rx.tap.map { self.isCheckedAll }.asObservable(),
      check: tableView.rx.itemSelected.asObservable(),
      next: nextButton.rx.tap.map { [weak self] _ -> Bool in
        guard let self = self else { return false }
        return self.isCheckedAll
      }.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    output.checkedAll.subscribe(onNext: {
      self.isCheckedAll = $0
      self.checkAllButton.setImage(UIImage(named: $0 ? "icRegChecked" : "icRegUnchecked"), for: .normal)
    }).disposed(by: disposeBag)
    
    output.terms.drive(self.tableView.rx.items(dataSource: self.dataSource)).disposed(by: disposeBag)
    
    output.nextEnabled.drive(self.nextButton.rx.isEnabled).disposed(by: disposeBag)
    
    output.registrationEmail.drive(onNext: { viewModel in
      self.navigator.show(segue: .registrationEmail(viewModel: viewModel), sender: self, transition: .navigation(.right))
    }).disposed(by: disposeBag)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .systemGray00
    self.setupBackButton()
    
    self.navigationItem.title = "약관 및 정책"
    self.nextButton.isEnabled = false
    
  }

  override func setupView() {
    super.setupView()
    [titleLabel, checkAllButton, checkAllLabel, divider,tableView, nextButton].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(24)
    }
    
    checkAllButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(39)
      $0.leading.equalTo(24)
      $0.width.height.equalTo(24)
    }
    
    checkAllLabel.snp.makeConstraints {
      $0.leading.equalTo(checkAllButton.snp.trailing).offset(10)
      $0.centerY.equalTo(checkAllButton)
    }
    
    divider.snp.makeConstraints {
      $0.top.equalTo(checkAllButton.snp.bottom).offset(8)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(divider.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(nextButton.snp.top)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-46)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(44)
    }
  }
}
