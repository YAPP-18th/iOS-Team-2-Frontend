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
    let feedSelected: Observable<FeedListTableViewCellViewModel>
  }
  
  struct Output {
    let items: BehaviorRelay<[FeedListSection]>
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
  let currentDate = BehaviorRelay<String>(value: "")
  let brave = BehaviorRelay<String>(value: BraveWord.default)
  let feedSelection = PublishSubject<PostResponse>()
  let userSelection = PublishSubject<UserInfo>()
  let likeChanged = PublishRelay<(IndexPath, FeedListTableViewCellViewModel)>()
  func transform(input: Input) -> Output {
    let elements = BehaviorRelay<[FeedListSection]>(value: [])
    
    feedElements.map { feedList -> [FeedListSection] in
      var elements: [FeedListSection] = []
      let cellViewModel = feedList.map { feed -> FeedListSection.Item in
        let viewModel = FeedListTableViewCellViewModel.init(with: feed)
        viewModel.userSelection.bind(to: self.userSelection).disposed(by: self.disposeBag)
        viewModel.likeButtonDidTap.bind { feed in
          self.likePost(feed: feed)
        }.disposed(by: self.disposeBag)
        return viewModel
      }
      
      elements.append(FeedListSection(items: cellViewModel))
      return elements
    }.bind(to: elements).disposed(by: disposeBag)
    
    let profile = userSelection.map({ userInfo -> FeedProfileViewModel in
      let viewModel = FeedProfileViewModel(userInfo: userInfo)
      return viewModel
    })
    
    currentDate.accept(dateFormatter.string(from: Date()))
    let braveWord = BraveWord()
    brave.accept(braveWord.randomBrave() ?? BraveWord.default)
    
    let detail = input.feedSelected.map { data -> FeedDetailViewModel in
      return FeedDetailViewModel(feed: data.feed)
    }
    
    fetchFeedList()
    
    return Output(
      items: elements,
      profile: profile,
      detail: detail,
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
