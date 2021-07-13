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
  }
  
  let feedMessageElements = BehaviorRelay<[CommentResponse]>(value: [])
  let contentImageURL = BehaviorRelay<[String]>(value: [])
  let deleteComment = PublishSubject<CommentResponse>()
  let commentAddSuccess = PublishSubject<Void>()
  
  func transform(input: Input) -> Output {
    input.addComment.subscribe(onNext: { comment in
      let requestDTO = CommentRequestDTO(content: comment)
      self.addComment(requestDTO: requestDTO)
    }).disposed(by: self.disposeBag)
    
    deleteComment.subscribe(onNext: { comment in
      self.deleteComment(commentId: comment.commentId)
    }).disposed(by: self.disposeBag)
    contentImageURL.accept(feed.images)
    return .init(
      feed: .just(self.feed)
    )
  }
  
  func addComment(requestDTO: CommentRequestDTO) {
    self.provider.addCommentRequesst(postId: self.feed.postId, requestDTO: requestDTO).subscribe(onNext: { result in
      self.commentAddSuccess.onNext(())
      self.fetchCommentList()
    }).disposed(by: disposeBag)
  }
  
  func fetchCommentList() {
    self.provider.fetchComments(postId: self.feed.postId).subscribe(onNext: { result in
      switch result {
      case let .success(list):
        self.feedMessageElements.accept(list.data ?? [])
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
