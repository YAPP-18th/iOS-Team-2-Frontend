//
//  SelectMenuViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/03.
//

import Foundation
import RxSwift
import RxCocoa

struct MenuInfo {
  var menu: String?
  var menuCount = 1
  var container: String? = "냄비"
  var containerCount = 1
  var last: Bool
}

class SelectMenuViewModel: ViewModel, ViewModelType {
  struct Input {
    let tipButtonDidTap: Observable<Void>
    let containerTextFieldDidBeginEditing: PublishRelay<Int>
    let addMenuButtonDidTap: PublishRelay<Void>
    let removeCell: PublishRelay<Int>
    let menuCountChanged: PublishSubject<(count: Int, index: Int)>
    let containerCountChanged: PublishSubject<(count: Int, index: Int)>
    let menuText: PublishSubject<(txt: String?, index: Int)>

  }
  
  struct Output {
    let menuInfo: BehaviorSubject<[MenuInfo]>
    let buttonEnabled: BehaviorRelay<Bool>
    let containerListView: PublishRelay<SelectContainerViewModel>
  }
  
  
  func transform(input: Input) -> Output {
    var menus: [MenuInfo] = [.init(last: false), .init(last: true)]
    let menuInfoOutput = BehaviorSubject<[MenuInfo]>(value: menus)
    let buttonEnabledOutput = BehaviorRelay<Bool>(value: false)
    let containerListViewOutput = PublishRelay<SelectContainerViewModel>()
    
    input.containerTextFieldDidBeginEditing
      .bind { index in
        containerListViewOutput.accept(SelectContainerViewModel())
      }.disposed(by: disposeBag)
    
    
    input.addMenuButtonDidTap
      .subscribe(onNext:{
        menus.insert(.init(last: false), at: menus.count-1)
        menuInfoOutput.onNext(menus)
      }).disposed(by: disposeBag)
    
    input.removeCell
      .subscribe(onNext: { index in
        guard menus.count > 2 else { return }
        menus.remove(at: index)
        menuInfoOutput.onNext(menus)
      }).disposed(by: disposeBag)
    
    input.menuCountChanged
      .subscribe(onNext: {
        menus[$0.index].menuCount += $0.count
        if menus[$0.index].menuCount == 0 {
          menus[$0.index].menuCount = 1
        }
        menuInfoOutput.onNext(menus)
      }).disposed(by: disposeBag)
    
    input.containerCountChanged
      .subscribe(onNext: {
        menus[$0.index].containerCount += $0.count
        if menus[$0.index].containerCount == 0 {
          menus[$0.index].containerCount = 1
        }
        menuInfoOutput.onNext(menus)
      }).disposed(by: disposeBag)

    input.menuText
      .subscribe(onNext: {
        menus[$0.index].menu = $0.txt
        menuInfoOutput.onNext(menus)
      }).disposed(by: disposeBag)
        
    menuInfoOutput
      .map {self.checkNextButtonValid($0)}
      .bind(to: buttonEnabledOutput)
      .disposed(by: disposeBag)
    
    
    return Output(menuInfo: menuInfoOutput,
                  buttonEnabled: buttonEnabledOutput,
                  containerListView: containerListViewOutput)
  }
  
  private func checkNextButtonValid(_ datas: [MenuInfo]) -> Bool {
    for i in 0..<datas.count-1 {
      let data = datas[i]
      if data.container == nil || data.menu == nil || data.container?.count == 0 || data.menu?.count == 0 {
        return false
      }
    }
    return true
  }
  
}
