//
//  PackageSimpleModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
import RxDataSources
struct PackageSimpleModel : IdentifiableType{
  let identity: Int
  let title: String
  let size: String
  let selected:Bool
}
extension PackageSimpleModel : Equatable {
  static func == (lds : PackageSimpleModel, rds : PackageSimpleModel) -> Bool {
    return (lds.title == rds.title) && (lds.size == rds.size)
  }
}
