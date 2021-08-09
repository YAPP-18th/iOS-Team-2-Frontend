//
//  SelectContainerViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol SelectContainerDelegate: AnyObject {
  func containerTitle(_ title: String, _ size: String)
}

class SelectContainerViewModel: ViewModel, ViewModelType {
  struct Input {
    let favoriteDidTap: PublishSubject<IndexPath>
    let itemSelected: Observable<IndexPath>
  }
  
  struct Output {
    let containers: Observable<[ContainerSection]>
    let dismiss: PublishRelay<Void>
  }
  
  weak var delegate: SelectContainerDelegate?

  func transform(input: Input) -> Output {
    let model = SelectContainerModel.shared
    
    let containerItems = BehaviorSubject<[ContainerSection]>(value: model.containers())
    let dismiss = PublishRelay<Void>()
    
    input.itemSelected
      .map { (model.container($0.section).items[$0.row].title,
              model.container($0.section).items[$0.row].size) }
      .subscribe(onNext: { [weak self] in
        self?.delegate?.containerTitle($0.0, $0.1)
        dismiss.accept(())
      }).disposed(by: disposeBag)
    
    input.favoriteDidTap
      .map{model.favoriteDidTap($0.section, $0.row)}
      .subscribe(onNext: {
        containerItems.onNext(model.containers())
      }).disposed(by: disposeBag)
    
 
    return Output(containers: containerItems,
                  dismiss: dismiss)
  }
  

}
