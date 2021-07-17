//
//  ImageDownloadManager.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/29.
//

import UIKit
import Alamofire
import RxSwift
class ImageDownloadManager{
  static let shared = ImageDownloadManager()
  private let cache = MemoryCache()
  private var runningRequests: [UUID: DataRequest] = [:]
  private let thumbnailImage = UIImage(named: "icPostThumbnail")!
  private init() { }
  
  func downloadImage(url: String) -> Observable<UIImage>{
    
    return Observable.create { observer in
      self.cache.retrieve(url) { (image: UIImage?) in
        if let image = image {
          observer.onNext(image)
          observer.onCompleted()
          
        } else {
          AF.request(url).responseData { (response) in
            switch response.result{
            case .success(let data):
              if let imageToCache = UIImage(data: data){
                self.cache.store(key: url, object: imageToCache) {
                  observer.onNext(imageToCache)
                  observer.onCompleted()
                }
              }else{
                observer.onNext(UIImage())
                observer.onCompleted()
              }
            case .failure(let error):
              observer.onError(error)
            }
          }
        }
      }
        return Disposables.create()
      }
      
    }
    
    
    @discardableResult
    func downloadImage(with url: String, completion: @escaping (UIImage) -> Void) -> UUID? {
      var uuid: UUID?
      self.cache.retrieve(url) { (image: UIImage?) in
        if let image = image {
          completion(image)
        } else {
          uuid = UUID()
          let request = AF.request(url).responseData { (response) in
            defer {
              self.runningRequests.removeValue(forKey: uuid!)
            }
            switch response.result{
            case .success(let data):
              if let imageToCache = UIImage(data: data){
                self.cache.store(key: url, object: imageToCache) {
                  DispatchQueue.main.async {
                    completion(imageToCache)
                  }
                }
              }else{
                DispatchQueue.main.async {
                  completion(self.thumbnailImage)
                }
              }
            case .failure:
              completion(self.thumbnailImage)
            }
          }
          self.runningRequests[uuid!] = request
        }
      }
      
      return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
  }
