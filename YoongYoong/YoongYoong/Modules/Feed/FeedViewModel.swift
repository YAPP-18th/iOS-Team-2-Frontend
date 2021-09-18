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
    let login: PublishSubject<Void>
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
  let likeChanged = PublishRelay<(IndexPath)>()
  func transform(input: Input) -> Output {
    let login = PublishSubject<Void>()
    currentDate.accept(dateFormatter.string(from: Date()))
    let braveWord = BraveWord()
    brave.accept(braveWord.randomBrave() ?? BraveWord.default)
    
    input.feedSelected.subscribe(onNext: { IndexPath in
      let feed = self.feedElements.value.reversed()[IndexPath.row]
      let viewModel = FeedDetailViewModel(feed: feed)
      self.feedDetail.onNext(viewModel)
    }).disposed(by: disposeBag)
    
    likeChanged.subscribe(onNext: { indexPath in
      if LoginManager.shared.isLogin, LoginManager.shared.loginStatus == .logined {
        let feed = self.feedElements.value.reversed()[indexPath.row]
        self.likePost(feed: feed)
      } else {
        login.onNext(())
      }
      
    }).disposed(by: disposeBag)
    
    return Output(
      items: feedElements,
      profile: self.userSelection,
      detail: self.feedDetail,
      login: login
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
    provider.likePost(feedId: feed.postId)
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
