//
//  FeedDetailViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class FeedDetailViewModel : ViewModel, ViewModelType {
  private var feed: PostResponse
  private let provider: PostService
  
  init(feed: PostResponse, provider: PostService = .init()) {
    self.feed = feed
    self.provider = provider
    super.init()
  }
  struct Input {
    let addComment: Observable<String>
  }
  
  struct Output {
    let feed: Driver<PostResponse>
    let items: BehaviorRelay<[FeedDetailMessageSection]>
  }
  
  let feedMessageElements = PublishSubject<[CommentResponse]>()
  let contentImageURL = BehaviorRelay<[String]>(value: [])
  let deleteComment = PublishSubject<CommentResponse>()
  
  func transform(input: Input) -> Output {
    input.addComment.subscribe(onNext: { comment in
      let requestDTO = CommentRequestDTO(content: comment)
      self.addComment(requestDTO: requestDTO)
    }).disposed(by: self.disposeBag)
    
    deleteComment.subscribe(onNext: { comment in
      self.deleteComment(commentId: comment.commentId)
    }).disposed(by: self.disposeBag)
    let elements = BehaviorRelay<[FeedDetailMessageSection]>(value: [])
    contentImageURL.accept(feed.images)
    feedMessageElements.map { feedList -> [FeedDetailMessageSection] in
      var elements: [FeedDetailMessageSection] = []
      let cellViewModel = feedList.map { feed -> FeedDetailMessageSection.Item in
        FeedDetailMessageTableViewCellViewModel.init(with: feed)
      }
      elements.append(FeedDetailMessageSection(items: cellViewModel))
      return elements
    }.bind(to: elements).disposed(by: disposeBag)
    
    fetchCommentList()
    return .init(
      feed: .just(self.feed),
      items: elements
    )
  }
  
  func addComment(requestDTO: CommentRequestDTO) {
    self.provider.addCommentRequesst(postId: self.feed.postId, requestDTO: requestDTO).subscribe(onNext: { result in
      self.fetchCommentList()
    }).disposed(by: disposeBag)
  }
  
  func fetchCommentList() {
    self.provider.fetchComments(postId: self.feed.postId).subscribe(onNext: { result in
      switch result {
      case let .success(list):
        self.feedMessageElements.onNext(list.data ?? [])
      case let .failure(error):
        print(error.localizedDescription)
      }
    }, onError: { (error) in
      print(error.localizedDescription)
    }).disposed(by: self.disposeBag)
  }
  
  func deleteComment(commentId: Int) {
    self.provider.deleteComment(postId: self.feed.postId, commentId: commentId)
      .subscribe(onNext: { result in
        self.fetchCommentList()
      }).disposed(by: disposeBag)
  }
}
