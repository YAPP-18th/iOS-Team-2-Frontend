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
  private let cache = NSCache<NSString, UIImage>()
  static let shared = ImageDownloadManager()
  
  private var runningRequests: [UUID: DataRequest] = [:]
  
  private init() { }
  func downloadImage(url: String) -> Observable<UIImage?>{
    return Observable.create { observer in
      let thumbnailImage = UIImage(named: "thumbnail")
      if let cachedImage = self.cache.object(forKey: NSString(string: url)){
        observer.onNext(cachedImage)
      }else{
        AF.request(url).responseData { (response) in
          switch response.result{
          case .success(let data):
            if let imageToCache = UIImage(data: data){
              self.cache.setObject(imageToCache, forKey: NSString(string: url))
              DispatchQueue.main.async {
                observer.onNext(imageToCache)
              }
            }else{
              DispatchQueue.main.async {
                observer.onNext(thumbnailImage)
              }
            }
          case .failure(let error):
            print(error.localizedDescription)
            observer.onNext(thumbnailImage)
          }
        }
      }
      return Disposables.create()
    }
    
  }
  
  func downloadImage(with url: String, completion: @escaping (UIImage?) -> Void) -> UUID? {
    if let cachedImage = self.cache.object(forKey: NSString(string: url)){
      completion(cachedImage)
      return nil
    }
    
    let uuid = UUID()
    let request = AF.request(url).responseData { (response) in
      defer {
        self.runningRequests.removeValue(forKey: uuid)
      }
      switch response.result{
      case .success(let data):
        if let imageToCache = UIImage(data: data){
          self.cache.setObject(imageToCache, forKey: NSString(string: url))
          DispatchQueue.main.async {
            completion(imageToCache)
          }
        }else{
          DispatchQueue.main.async {
            completion(nil)
          }
        }
      case .failure(let error):
        print(error.localizedDescription)
        completion(nil)
      }
    }
    
    runningRequests[uuid] = request
    return uuid
    
  }
  
  func cancelLoad(_ uuid: UUID) {
    runningRequests[uuid]?.cancel()
    runningRequests.removeValue(forKey: uuid)
  }
}
