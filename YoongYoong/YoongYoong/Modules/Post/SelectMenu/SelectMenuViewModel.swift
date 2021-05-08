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
  var container: String?
  var containerCount = 1
}

class SelectMenuViewModel: ViewModel, ViewModelType {
  struct Input {
    let tipButtonDidTap: Observable<Void>
    var containerTextFieldDidBeginEditing: BehaviorRelay<Int?>
  }
  
  struct Output {
    var info: BehaviorRelay<[MenuInfo]> = BehaviorRelay(value: [])
    let buttonEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    // tip
    var containerListView: BehaviorRelay<SelectContainerViewModel?> = BehaviorRelay(value: nil)
  }
  var output = Output()
  
  func transform(input: Input) -> Output {
     input.containerTextFieldDidBeginEditing
      .skip(1)
      .map { $0 != nil }
      .subscribe(onNext: { _ in
        self.output.containerListView.accept(SelectContainerViewModel())
      }).disposed(by: disposeBag)
    
    output.info.accept(menus)
    
    output.info
      .map {self.checkNextButtonValid($0)}
      .subscribe(onNext: { [weak self] bool in
        guard let self = self else { return }
        self.output.buttonEnabled.accept(bool)
      }).disposed(by: disposeBag)
    
    return output
  }
  
  var menus: [MenuInfo] = [.init(), .init()]
  
  func addMenu() {
    menus.insert(.init(), at: menus.count-1)
    output.info.accept(menus)
  }
  
  func removeCellDidTap(at index: Int) {
    guard menus.count > 2 else { return }
    menus.remove(at: index)
    output.info.accept(menus)
  }
  
  func increaseMenuCount(at index: Int) {
    guard menus[index].menuCount < 100 else { return }
    menus[index].menuCount += 1
    output.info.accept(menus)
  }
  
  func decreaseMenuCount(at index: Int) {
    guard menus[index].menuCount > 1 else { return }
    menus[index].menuCount -= 1
    output.info.accept(menus)
  }
  
  func increaseContainerCount(at index: Int) {
    guard menus[index].containerCount < 100 else { return }
    menus[index].containerCount += 1
    output.info.accept(menus)
  }
  
  func decreaseContainerCount(at index: Int) {
    guard menus[index].containerCount > 1 else { return }
    menus[index].containerCount -= 1
    output.info.accept(menus)
  }
  
  

  
  private func checkNextButtonValid(_ datas: [MenuInfo]) -> Bool {
    for i in 0..<datas.count-1 {
      let data = datas[i]
      if data.container == nil || data.menu == nil {
        return false
      }
    }
    return true
  }
  
}
