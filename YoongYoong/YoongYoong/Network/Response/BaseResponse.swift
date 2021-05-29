//
//  BaseResponse.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/29.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    // MARK: Properties
    var count: Int = 0
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case count
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseResponse.CodingKeys.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
    
}
