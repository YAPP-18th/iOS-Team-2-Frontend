//
//  Cashable.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/17.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation
import UIKit

public protocol Cachable {
    associatedtype CacheType
    
    static func decode(_ data: Data) -> CacheType?
    func encode() -> Data?
}

extension UIImage: Cachable {
    public typealias CacheType = UIImage
    public static func decode(_ data: Data) -> CacheType? {
        let image = UIImage(data: data)
        return image
    }
    
    public func encode() -> Data? {
        return self.pngData()
    }
    
}

public protocol Cache {
    func store<T: Cachable>(key: String, object: T, completion: (() -> Void)?)
    
    func retrieve<T: Cachable>(_ key: String, completion: @escaping (_ object: T?) -> Void)
    
    func remove(_ key: String, completion: (() -> Void)?)
}

class MemoryCache: Cache {
    public let cache = NSCache<AnyObject, AnyObject>()
    
    func store<T>(key: String, object: T, completion: (() -> Void)?) where T : Cachable {
        cache.setObject(object as AnyObject, forKey: key as AnyObject)
        completion?()
    }
    
    func retrieve<T>(_ key: String, completion: @escaping (T?) -> Void) where T : Cachable {
        let object = cache.object(forKey: key as AnyObject)
        completion(object as? T)
    }
    
    func remove(_ key: String, completion: (() -> Void)?) {
        cache.removeObject(forKey: key as AnyObject)
        completion?()
    }
    
}
