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

class SelectContainerViewModel: ViewModel, ViewModelType {
  struct Input {
    let favoriteDidTap: PublishSubject<IndexPath>
    let itemSelected: Observable<IndexPath>
  }
  
  struct Output {
    let containers: Observable<[ContainerSection]>
    let dismiss: PublishRelay<Void>
  }

  func transform(input: Input) -> Output {
    var dummy: [ContainerSection] = [
      .init(id: 0, items: [
        .init(identity: 0, title: "냄비", size: "S", selected: true),
        .init(identity: 1, title: "냄비", size: "M", selected: true),
        .init(identity: 2, title: "냄비", size: "L", selected: true),
        .init(identity: 3, title: "텀블러", size: "M", selected: true),
        .init(identity: 4, title: "프라이팬", size: "L", selected: true)
      ]),
      .init(id: 1, items: [
        .init(identity: 0, title: "밀폐 용기", size: "S", selected: false),
        .init(identity: 1, title: "밀폐 용기", size: "M", selected: false),
        .init(identity: 2, title: "밀폐 용기", size: "L", selected: false)
      ]),
      
      .init(id: 2, items: [
        .init(identity: 0, title: "냄비", size: "S", selected: true),
        .init(identity: 1, title: "냄비", size: "M", selected: true),
        .init(identity: 2, title: "냄비", size: "L", selected: true)
      ]),
      
      .init(id: 3, items: [
        .init(identity: 0, title: "텀블러", size: "S", selected: false),
        .init(identity: 1, title: "텀블러", size: "M", selected: true),
        .init(identity: 2, title: "텀블러", size: "L", selected: false)
      ]),
      
      .init(id: 4, items: [
        .init(identity: 0, title: "보온 도시락", size: "S", selected: false),
        .init(identity: 1, title: "보온 도시락", size: "M", selected: false),
        .init(identity: 2, title: "보온 도시락", size: "L", selected: false)
      ]),
      
      .init(id: 5, items: [
        .init(identity: 0, title: "프라이팬", size: "S", selected: false),
        .init(identity: 1, title: "프라이팬", size: "M", selected: false),
        .init(identity: 2, title: "프라이팬", size: "L", selected: true)
      ]),
    ]
    
    let containerItems = BehaviorSubject<[ContainerSection]>(value: dummy)
    let dismiss = PublishRelay<Void>()
    
    input.itemSelected
      .subscribe(onNext: {
        print($0)
        //TODO: Delegate
        
        dismiss.accept(())
      }).disposed(by: disposeBag)
    
    input.favoriteDidTap
      .subscribe(onNext: {
        dummy[$0.section].items[$0.row].selected = !dummy[$0.section].items[$0.row].selected
        containerItems.onNext(dummy)
      }).disposed(by: disposeBag)
    
 

    return Output(containers: containerItems,
                  dismiss: dismiss)
  }
  

}
