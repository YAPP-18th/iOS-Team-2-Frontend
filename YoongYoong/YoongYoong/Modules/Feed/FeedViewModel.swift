//
//  FeedViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import Foundation
import RxCocoa
import RxSwift

class FeedViewModel: ViewModel, ViewModelType {
  
  private let provider: PostService
  
  init(provider: PostService = .init()) {
    self.provider = provider
  }
  struct Input {
    let feedSelected: Observable<IndexPath>
  }
  
  struct Output {
    let items: BehaviorRelay<[PostResponse]>
    let profile: Observable<FeedProfileViewModel>
    let detail: Observable<FeedDetailViewModel>
    let likeChanged: Observable<(IndexPath, FeedListTableViewCellViewModel)>
  }
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yy.MM.dd EEE"
    return formatter
  }()
  
  let feedElements = BehaviorRelay<[PostResponse]>(value: [])
  let feedDetail = PublishSubject<FeedDetailViewModel>()
  let currentDate = BehaviorRelay<String>(value: "")
  let brave = BehaviorRelay<String>(value: BraveWord.default)
  let userSelection = PublishSubject<FeedProfileViewModel>()
  let likeChanged = PublishRelay<(IndexPath, FeedListTableViewCellViewModel)>()
  func transform(input: Input) -> Output {
    
    currentDate.accept(dateFormatter.string(from: Date()))
    let braveWord = BraveWord()
    brave.accept(braveWord.randomBrave() ?? BraveWord.default)
    
    input.feedSelected.subscribe(onNext: { IndexPath in
      let feed = self.feedElements.value[IndexPath.row]
      let viewModel = FeedDetailViewModel(feed: feed)
      self.feedDetail.onNext(viewModel)
    }).disposed(by: disposeBag)
    
    fetchFeedList()
    
    return Output(
      items: feedElements,
      profile: self.userSelection,
      detail: self.feedDetail,
      likeChanged: self.likeChanged.asObservable()
    )
  }
  
  func fetchFeedList() {
    self.provider.fetchAllPosts().subscribe(onNext: { result in
      switch result {
      case let .success(list):
        self.feedElements.accept(list.data ?? [])
      case let .failure(error):
        print(error.localizedDescription)
      }
    }, onError: { (error) in
      print(error.localizedDescription)
    }).disposed(by: self.disposeBag)
  }
  
  func selectUser(user: UserInfo) {
    let viewModel = FeedProfileViewModel(userInfo: user)
    self.userSelection.onNext(viewModel)
  }
  
  func likePost(feed: PostResponse) {
    provider.likePost(feed: feed)
      .subscribe(onNext: { result in
        switch result {
        case .success:
          var newFeed = feed
          newFeed.isLikePressed = !feed.isLikePressed
          newFeed.likeCount = newFeed.isLikePressed ? newFeed.likeCount + 1 : newFeed.likeCount - 1
          var newFeedElements = self.feedElements.value
          if let index = newFeedElements.firstIndex(where: { $0.postId == feed.postId }) {
            newFeedElements[index] = newFeed
            self.feedElements.accept(newFeedElements)
          }
          
        case let .failure(error):
          print(error.localizedDescription)
        }
      }).disposed(by: self.disposeBag)
  }
}
