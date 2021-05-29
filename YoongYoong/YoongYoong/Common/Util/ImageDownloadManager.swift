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
}
