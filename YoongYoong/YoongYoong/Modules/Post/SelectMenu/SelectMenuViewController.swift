//
//  SelectMenuViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/03.
//

import UIKit
import RxSwift
import RxCocoa

class SelectMenuViewController: ViewController {
  
  private let titleLabel = UILabel().then {
    $0.text = "어떤 용기를 냈나요?"
    $0.font = UIFont.sdGhothicNeo(ofSize: 24, weight: .regular)
  }
  
  private let tipButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavTIp"), for: .normal)
  }
  
  private let tableView = UITableView()
  private let nextButton = UIButton().then {
    $0.layer.cornerRadius = 30.0
    $0.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.9137254902, blue: 0.8039215686, alpha: 1)
    $0.isEnabled = false
    $0.setTitle("계속하기", for: .normal)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel as? SelectMenuViewModel else { return }
    
    let input = SelectMenuViewModel.Input(tipButtonDidTap: tipButton.rx.tap.asObservable())
    
    let output = viewModel.transform(input: input)
    
    output.info
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: MenuInfoCell.reuseIdentifier, cellType: MenuInfoCell.self)) { [weak self] index, info, cell in
        guard let self = self else { return }
        cell.setSeletedColor()
        if index == viewModel.menus.count-1 {
          cell.addMenuButton.isHidden = false
          cell.headerView.isHidden = true
          cell.bodyView.isHidden = true
          
          cell.addMenuDidTap = {
            viewModel.addMenu()
            self.tableView.scrollToRow(at: IndexPath(row: index+1, section: 0), at: .bottom, animated: true)
          }
        } else {
          cell.menuTextField.text = info.menu
          cell.menuCountLabel.text = "\(info.menuCount)"
          cell.containerTextField.text = info.container
          cell.containerCountLabel.text = "\(info.containerCount)"

          cell.didDelete = {
            viewModel.removeCellDidTap(at: index)
          }
          cell.menuMinusDidTap = {
            viewModel.decreaseMenuCount(at: index)
          }
          cell.menuPlusDidTap = {
            viewModel.increaseMenuCount(at: index)
          }
          cell.containerMinusDidTap = {
            viewModel.decreaseContainerCount(at: index)
          }
          cell.containerPlusDidTap = {
            viewModel.increaseContainerCount(at: index)
          }
        }

 
      }.disposed(by: disposeBag)
    
    output.buttonEnabled
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] flag in
        guard let self = self else { return }
        self.nextButton.isEnabled = flag
        self.nextButton.backgroundColor = flag ? #colorLiteral(red: 0.0862745098, green: 0.8039215686, blue: 0.5647058824, alpha: 1) : #colorLiteral(red: 0.6196078431, green: 0.9137254902, blue: 0.8039215686, alpha: 1)
      }).disposed(by: disposeBag)
    
    nextButton.rx.tap.bind {
      print("nextButton")
    }.disposed(by: disposeBag)
    
  }
    
  override func setupView() {
    super.setupView()
    view.adds([titleLabel, tipButton, tableView, nextButton])
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    titleLabel.snp.makeConstraints {
      $0.left.equalTo(view.snp.left).offset(16)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
      $0.height.equalTo(34)
    }
    
    tipButton.snp.makeConstraints {
      $0.left.equalTo(titleLabel.snp.right)
      $0.width.height.equalTo(34)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
    }
    
    tableView.snp.makeConstraints {
      $0.left.right.bottom.equalTo(view)
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
    }
    
    nextButton.snp.makeConstraints {
      $0.width.equalTo(144)
      $0.height.equalTo(55)
      $0.centerX.equalTo(view.snp.centerX)
      $0.bottom.equalTo(view.snp.bottom).offset(-67)
    }
    
  }
  
  override func configuration() {
    super.configuration()
    tableView.do {
      $0.register(MenuInfoCell.self, forCellReuseIdentifier: MenuInfoCell.reuseIdentifier)
      $0.estimatedRowHeight = MenuInfoCell.height + 20
      $0.separatorStyle = .none
      $0.rowHeight = MenuInfoCell.height
    }
    
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
  }
  
}

extension SelectMenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  
}


