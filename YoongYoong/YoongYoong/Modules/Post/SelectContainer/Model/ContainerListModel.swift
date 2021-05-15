//
//  ContainerListModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/14.
//

import Foundation
import RxDataSources

enum Container: Int, CaseIterable {
  case favorite = 0, airtight ,pot, tumbler, lunchBox, fryingPan

  static func sectionTitle(_ rawValue: Int) -> String {
    switch Container.init(rawValue: rawValue) {
    case .favorite:
      return "자주 쓰는 용기"
    case .airtight:
      return "밀폐 용기"
    case .pot:
      return "냄비"
    case .tumbler:
      return "텀블러"
    case .lunchBox:
      return "보온 도시락"
    case .fryingPan:
      return "프라이팬"
    default:
      return ""
    }
  }
  
  static func sectionImage(_ rawValue: Int) -> UIImage? {
    switch Container.init(rawValue: rawValue) {
    case .favorite:
      return UIImage(named: "packagefavorate")
    case .airtight:
      return UIImage(named: "packageLock")
    case .pot:
      return UIImage(named: "packagePot")
    case .tumbler:
      return UIImage(named: "packageTumbler")
    case .lunchBox:
      return UIImage(named: "packageLunchbox")
    case .fryingPan:
      return UIImage(named: "packageFryingPan")
    default:
      return nil
    }
  }
  
}

struct ContainerCellModel: IdentifiableType {
  let identity: Int
  let title: String
  let size: String
  var selected: Bool
}

extension ContainerCellModel: Equatable {}

struct ContainerSection {
  let id: Int
  var items: [Item]
}

extension ContainerSection: AnimatableSectionModelType {
  typealias Item = ContainerCellModel
  init(original: ContainerSection, items: [Item]) {
    self = original
    self.items = items
  }
  
  var identity: Int {
    return id
  }
}
