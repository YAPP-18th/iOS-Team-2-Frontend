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
    var dummy: [ContainerSection] = [
      .init(id: 0, items: []),
      .init(id: 1, items: [
        .init(identity: "밀폐 용기/S", title: "밀폐 용기", size: "S", selected: false),
        .init(identity: "밀폐 용기/M", title: "밀폐 용기", size: "M", selected: false),
        .init(identity: "밀폐 용기/L", title: "밀폐 용기", size: "L", selected: false)
      ]),
      
      .init(id: 2, items: [
        .init(identity: "냄비/S", title: "냄비", size: "S", selected: false),
        .init(identity: "냄비/M", title: "냄비", size: "M", selected: false),
        .init(identity: "냄비/L", title: "냄비", size: "L", selected: false)
      ]),
      
      .init(id: 3, items: [
        .init(identity: "텀블러/S", title: "텀블러", size: "S", selected: false),
        .init(identity: "텀블러/M", title: "텀블러", size: "M", selected: false),
        .init(identity: "텀블러/L", title: "텀블러", size: "L", selected: false)
      ]),
      
      .init(id: 4, items: [
        .init(identity: "보온 도시락/S", title: "보온 도시락", size: "S", selected: false),
        .init(identity: "보온 도시락/M", title: "보온 도시락", size: "M", selected: false),
        .init(identity: "보온 도시락/L", title: "보온 도시락", size: "L", selected: false)
      ]),
      
      .init(id: 5, items: [
        .init(identity: "프라이팬/S", title: "프라이팬", size: "S", selected: false),
        .init(identity: "프라이팬/M", title: "프라이팬", size: "M", selected: false),
        .init(identity: "프라이팬/L", title: "프라이팬", size: "L", selected: false)
      ]),
    ]
    
    let containerItems = BehaviorSubject<[ContainerSection]>(value: dummy)
    let dismiss = PublishRelay<Void>()
    
    input.itemSelected
      .subscribe(onNext: { [weak self] in
        self?.delegate?.containerTitle(dummy[$0.section].items[$0.row].title, dummy[$0.section].items[$0.row].size)
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
