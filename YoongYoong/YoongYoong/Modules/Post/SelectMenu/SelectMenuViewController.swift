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
    $0.font = .krHeadline
  }
  
  private let tipButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavTIp"), for: .normal)
  }
  
  private let tableView = UITableView()
  private let nextButton = UIButton().then {
    $0.layer.cornerRadius = 30.0
    $0.backgroundColor = .brandColorGreen03
    $0.isEnabled = false
    $0.setTitle("계속하기", for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.layer.applySketchShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.12, x: 0, y: 2, blur: 10, spread: 0)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel as? SelectMenuViewModel else { return }
    
    let input = SelectMenuViewModel.Input(tipButtonDidTap: tipButton.rx.tap.asObservable(),
                                          containerTextFieldDidBeginEditing: PublishRelay<Int>(),
                                          addMenuButtonDidTap: PublishRelay<Void>(),
                                          removeCell: PublishRelay<Int>(),
                                          menuCountChanged: PublishSubject<(count: Int,index: Int)>(),
                                          containerCountChanged: PublishSubject<(count: Int,index: Int)>(),
                                          menuText: PublishSubject<(txt: String?, index: Int)>())
    
    let output = viewModel.transform(input: input)
    
    output.menuInfo
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: MenuInfoCell.reuseIdentifier, cellType: MenuInfoCell.self)) { [weak self] index, info, cell in
        guard let self = self else { return }
        
        cell.bind()
        
        if info.last == true {
          cell.setLastCell()
          cell.addMenuCell
            .bind { [weak self] in
              guard let self = self else { return }
              input.addMenuButtonDidTap.accept(())
              self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
            }.disposed(by: self.disposeBag)
            
        } else {
          cell.setCellData(info, index+1)
          cell.showContainerListView
            .bind {
              input.containerTextFieldDidBeginEditing.accept(index)
            }
            .disposed(by: self.disposeBag)
          
          cell.deleteCell
            .map {index}
            .bind(to: input.removeCell)
            .disposed(by: self.disposeBag)

          cell.menuText
            .map {($0, index)}
            .bind(to: input.menuText)
            .disposed(by: self.disposeBag)
          
          cell.menuCount
            .map { ($0, index) }
            .bind(to: input.menuCountChanged)
            .disposed(by: self.disposeBag)
          
          cell.containerCount
            .map { ($0, index) }
            .bind(to: input.containerCountChanged)
            .disposed(by: self.disposeBag)
          
        }

      }.disposed(by: disposeBag)
    
    output.buttonEnabled
      .subscribe(onNext: { [weak self] bool in
        guard let self = self else { return }
        self.nextButton.isEnabled = bool
        self.nextButton.backgroundColor = bool ? .brandColorGreen01 : .brandColorGreen03
      }).disposed(by: disposeBag)
    
    output.containerListView
      .subscribe(onNext: { [weak self] viewModel in
        guard let self = self else { return }
        self.present(SelectContainerViewController(viewModel: viewModel, navigator: self.navigator), animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    tipButton.rx.tap.bind {
      let tipVC = TipDetailViewController(viewModel: nil, navigator: self.navigator)
      tipVC.tipView = TipDetailFirstView()
      tipVC.tipView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      tipVC.tipView.layer.cornerRadius = 15
      tipVC.dimmView.isHidden = true
      self.present(tipVC, animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    nextButton.rx.tap.bind {
      self.navigator.show(segue: .addReview(viewModel: PostReviewViewModel()), sender: self, transition: .navigation())
    }.disposed(by: disposeBag)
    
  }
    
  override func setupView() {
    super.setupView()
    view.adds([titleLabel, tipButton, tableView, nextButton])
  }
  
  override func setupLayout() {
    super.setupLayout()
    view.backgroundColor = .white
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
    view.backgroundColor = .white
    tableView.do {
      $0.register(MenuInfoCell.self, forCellReuseIdentifier: MenuInfoCell.reuseIdentifier)
      $0.estimatedRowHeight = MenuInfoCell.height + 20
      $0.separatorStyle = .none
      $0.rowHeight = MenuInfoCell.height
    }
        
  }
  
}


