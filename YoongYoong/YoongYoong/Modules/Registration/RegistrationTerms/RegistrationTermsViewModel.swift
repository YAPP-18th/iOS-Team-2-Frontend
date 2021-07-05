//
//  RegistrationTermsViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationTermsViewModel : ViewModel, ViewModelType {
  struct Input {
    let checkAll: Observable<Bool>
    let check: Observable<IndexPath>
    let next: Observable<Bool>
  }
  struct Output {
    let checkedAll: Observable<Bool>
    let terms: Driver<[TermsCheckSection]>
    let nextEnabled: Driver<Bool>
    let registrationEmail: Driver<RegistrationEmailViewModel>
  }
  
  var terms = BehaviorRelay<[TermsCheckItem]>(value: [
    .init(id: 0, title: "(필수) 서비스 이용약관", selected: false),
    .init(id: 1, title: "(필수) 개인정보 처리방침", selected: false),
    .init(id: 2, title: "(필수) 위치 기반 서비스", selected: false),
    .init(id: 3, title: "(선택) 마케팅 정보 수신 동의", selected: false)
  ])
  var checkedAll = BehaviorRelay<Bool>(value: false)
  
  func transform(input: Input) -> Output {
    input.checkAll.subscribe(onNext: { isCheckedAll in
      let terms = self.terms.value
      for item in terms {
        item.selected = !isCheckedAll
      }
      self.terms.accept(terms)
    }).disposed(by: disposeBag)
    input.check.subscribe(onNext: { indexPath in
      let terms = self.terms.value
      terms[indexPath.row].selected = !terms[indexPath.row].selected
      self.terms.accept(terms)
    }).disposed(by: disposeBag)
    
    
    
    let checkedAll = self.terms.map { !$0.contains { $0.selected == false
    }}.asObservable()
    
    let terms = self.terms.map { items -> [TermsCheckSection] in
      let viewModels = items.map { TermsCheckTableViewCellViewModel(with: $0) }
      return [TermsCheckSection(items: viewModels)] }.asDriver(onErrorJustReturn: [])
    
    let nextEnabled = self.terms.map { $0[0].selected && $0[1].selected && $0[2].selected }.asDriver(onErrorJustReturn: false)
    
    let registrationEmail = input.next.asDriver(onErrorJustReturn: false).map { isMarkettingAgree -> RegistrationEmailViewModel in
      let viewModel = RegistrationEmailViewModel(isMarketingAgree: isMarkettingAgree)
      return viewModel
    }
    
    return .init(
      checkedAll: checkedAll,
      terms: terms,
      nextEnabled: nextEnabled,
      registrationEmail: registrationEmail
    )
  }
}
