//
//  ImageDownloadManager.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/29.
//

import UIKit
import Alamofire
class ImageDownloadManager{
    private let cache = NSCache<NSString, UIImage>()
    static let shared = ImageDownloadManager()
    private init() { }
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void){
        let thumbnailImage = UIImage(named: "thumbnail")
        if let cachedImage = cache.object(forKey: NSString(string: url)){
            completion(cachedImage)
        }else{
          AF.request(url).responseData { (response) in
                switch response.result{
                case .success(let data):
                    if let imageToCache = UIImage(data: data){
                        self.cache.setObject(imageToCache, forKey: NSString(string: url))
                        DispatchQueue.main.async {
                            completion(imageToCache)
                        }
                    }else{
                        DispatchQueue.main.async {
                            completion(thumbnailImage)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(thumbnailImage)
                }
            }
        }
    }
}
