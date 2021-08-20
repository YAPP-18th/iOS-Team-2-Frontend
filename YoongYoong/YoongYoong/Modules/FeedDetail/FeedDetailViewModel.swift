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
    
    enum CommentMode {
        case normal
        case edit(Int)
    }
    
    
  private var feed: PostResponse
  private let provider: PostService
  
  init(feed: PostResponse, provider: PostService = .init()) {
    self.feed = feed
    self.provider = provider
    super.init()
  }
  struct Input {
    let addComment: Observable<String>
    let like: Observable<Void>
    let edit: Observable<Void>
  }
  
  struct Output {
    let feed: Driver<PostResponse>
    let edit: Observable<PostReviewViewModel>
  }
  
  let back = PublishSubject<Void>()
  
  
  lazy var currentFeed = BehaviorRelay<PostResponse>(value: self.feed)
  let feedMessageElements = BehaviorRelay<[CommentResponse]>(value: [])
  let contentImageURL = BehaviorRelay<[String]>(value: [])
  let deleteComment = PublishSubject<CommentResponse>()
  let commentAddSuccess = PublishSubject<Void>()
    let commentMode = BehaviorRelay<CommentMode>(value: .normal)
  
  func transform(input: Input) -> Output {
    input.addComment.subscribe(onNext: { comment in
      let requestDTO = CommentRequestDTO(content: comment)
      self.addComment(requestDTO: requestDTO)
    }).disposed(by: self.disposeBag)
    input.like.subscribe(onNext: { _ in
      self.likePost(feed: self.currentFeed.value)
    }).disposed(by: self.disposeBag)
    deleteComment.subscribe(onNext: { comment in
      self.deleteComment(commentId: comment.commentId)
    }).disposed(by: self.disposeBag)
    contentImageURL.accept(feed.images)
    
    let edit = input.edit.map { _ -> PostReviewViewModel in
      return PostReviewViewModel(reviewMode: .edit(self.feed))
    }
    return .init(
      feed: currentFeed.asDriver(),
      edit: edit
    )
  }
  
  func addComment(requestDTO: CommentRequestDTO) {
    if case .normal = commentMode.value {
        self.provider.addCommentRequesst(postId: self.feed.postId, requestDTO: requestDTO).subscribe(onNext: { result in
          self.commentAddSuccess.onNext(())
          self.fetchCommentList()
        }).disposed(by: disposeBag)
    } else if case .edit(let commentId) = commentMode.value {
        self.provider.editCommentRequest(postId: self.feed.postId, commentId: commentId, requestDTO: requestDTO).subscribe(onNext: { result in
          self.commentAddSuccess.onNext(())
          self.fetchCommentList()
            self.commentMode.accept(.normal)
        }).disposed(by: disposeBag)
    }
    
    
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
  
  func likePost(feed: PostResponse) {
    provider.likePost(feedId: feed.postId)
      .subscribe(onNext: { result in
        switch result {
        case .success:
          var newFeed = self.currentFeed.value
          newFeed.isLikePressed = !feed.isLikePressed
          newFeed.likeCount = newFeed.isLikePressed ? newFeed.likeCount + 1 : newFeed.likeCount - 1
          self.currentFeed.accept(newFeed)
          
        case let .failure(error):
          print(error.localizedDescription)
        }
      }).disposed(by: self.disposeBag)
  }
  
  func deletePost() {
    provider.deletePost(feedId: feed.postId)
      .subscribe(onNext: { [weak self] result in
        guard let self = self else { return }
        if case .success = result {
          self.back.onNext(())
        }
      }).disposed(by: disposeBag)
  }
}
