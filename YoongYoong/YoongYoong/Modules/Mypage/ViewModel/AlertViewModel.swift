//
//  AlertViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/12.
//

import Foundation
import RxSwift
import RxCocoa
class AlertViewModel: ViewModel , ViewModelType {
  struct Input {
    let loadView : Observable<Void>
    let readAlert : Observable<(IndexPath,AlertModel)>
    let deleteAlert: Observable<(IndexPath,AlertModel)>
  }
  struct Output {
    let alertUsecase: Observable<[AlertModel]>
  }
}
extension AlertViewModel {
  // contentCell에 바인딩
  func transform(input: Input) -> Output {
    weak var weakSelf = self
    var useCase: [AlertModel] = []
    let dummyAlert = input.loadView.map{ _ -> [AlertModel] in
      return [AlertModel(id: 0, profile: "", aletTitle: "김용용님이 회원님의 글에 댓글을 남겼습니다. ", read: false),
       AlertModel(id: 1, profile: "", aletTitle: "‘첫 용기’ 배지를 획득했습니다.", read: true),
       AlertModel(id: 2, profile: "", aletTitle: "‘용기 마당발’ 배지를 획득했습니다.", read: true),
       AlertModel(id: 3, profile: "", aletTitle: "김용용님이 회원님의 글에 댓글을 남겼습니다. ", read: false),
       AlertModel(id: 4, profile: "", aletTitle: "김용용님이 회원님의 글에 댓글을 남겼습니다. ", read: true),
       AlertModel(id: 5, profile: "", aletTitle: "김용용님이 회원님의 글에 댓글을 남겼습니다. ", read: true),
       AlertModel(id: 6, profile: "", aletTitle: "김용용님이 회원님의 글에 댓글을 남겼습니다. ", read: true),
       AlertModel(id: 7, profile: "", aletTitle: "김용용님이 회원님의 글에 댓글을 남겼습니다. ", read: true)
       ]
      
    }
    let bindTrigger = dummyAlert.map{
      useCase = $0
    }
    let alertUsecase = bindTrigger.flatMapLatest{ _ in
      return weakSelf?.mutateUsecase(readAlert: input.readAlert,
                                     deleteAlert: input.deleteAlert,
                                     origin: useCase) ?? .empty()
    }.share()
    
    return .init(alertUsecase: alertUsecase)
  }
  func mutateUsecase(readAlert: Observable<(IndexPath,AlertModel)>,
                     deleteAlert :Observable<(IndexPath,AlertModel)>,
                     origin : [AlertModel]) -> Observable<[AlertModel]> {
    enum Action {
      case read(indexPath: IndexPath, model: AlertModel)
      case delete(indexPath: IndexPath, model: AlertModel)
    }
    return Observable.merge(readAlert.map(Action.read), deleteAlert.map(Action.delete))
      .scan(into: origin) {state, action in
        switch action {
        case .read(indexPath: let indexPath, model: let model):
          if state[indexPath.row].id == model.id {
            state[indexPath.row].read = true
          }
        case .delete(indexPath: let indexPath, model: let model):
          if state[indexPath.row].id == model.id {
            if state.count == 1 {
              state = []
            }
            else{
              state.remove(at: indexPath.row)
            }
          }
        }
        
      }.startWith(origin)
      
  }
}


