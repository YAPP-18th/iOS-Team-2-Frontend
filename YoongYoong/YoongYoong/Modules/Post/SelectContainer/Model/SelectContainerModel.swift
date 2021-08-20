//
//  SelectContainerModel.swift
//  
//
//  Created by 원현식 on 2021/06/16.
//

import Foundation

class SelectContainerModel {
  
    static let shared = SelectContainerModel()
  private init() { loadMyContainers() }
  
  func containers() -> [ContainerSection] {
    return defaultContainers
  }
  
  func container(_ section: Int) -> ContainerSection {
    return defaultContainers[section]
  }
  
  func favoriteDidTap(_ section: Int, _ row: Int) {
    if section == 0 { // favorite 해제
      let deselected = favorites.remove(at: row)
      defaultContainers[0].items = favorites.map { defaultContainers[$0.id].items[$0.size] }
      defaultContainers[deselected.id].items[deselected.size].isFavorite = false
    } else {
      // favorite section에 반영
      defaultContainers[section].items[row].isFavorite = !defaultContainers[section].items[row].isFavorite
      // favorite 해제
      if !defaultContainers[section].items[row].isFavorite {
        for i in 0..<favorites.count {
          let loc = favorites[i]
          if loc.id == section && loc.size == row {
            favorites.remove(at: i)
            break
          }
        }
        
        defaultContainers[0].items = favorites.map { defaultContainers[$0.id].items[$0.size]}
        
      } else {
        // favorite 등록
        favorites.append((section, row))
        defaultContainers[0].items = favorites.map { defaultContainers[$0.id].items[$0.size]}
      }
      
    }
    save(favorites)
  }
  
  private func save(_ favorites: [(id: Int, size: Int)]) {
    let data = favorites.map { defaultContainers[$0.id].items[$0.size].identity }
    UserDefaultHelper.set(data, forKey: .container)
  }
  
  private func loadMyContainers() {
    guard let data = UserDefaultStorage.myContainers else { return }
    favorites = data.map { containerInfo($0) }
    for (id, size) in favorites {
      defaultContainers[id].items[size].isFavorite = true
    }
    
    defaultContainers[0].items = favorites.map { defaultContainers[$0.id].items[$0.size] }
  }
  
  private func containerInfo(_ identity: String) -> (id: Int, size: Int) {
    let splited = identity.split(separator: "/").map{ String($0) }
    let id = splited[0].asContainerForm.rawValue
    var size = 0
    if splited[1] == "M" {
      size = 1
    } else if splited[1] == "L" {
      size = 2
    }
    return (id, size)
  }
  
  private var favorites: [(id: Int, size: Int)] = [] // pointers
  private var defaultContainers: [ContainerSection] = [
    .init(id: 0, items: []),
    .init(id: 1, items: [
      .init(identity: "밀폐용기/S", title: "밀폐용기", size: "S", isFavorite: false),
      .init(identity: "밀폐용기/M", title: "밀폐용기", size: "M", isFavorite: false),
      .init(identity: "밀폐용기/L", title: "밀폐용기", size: "L", isFavorite: false)
    ]),
    
    .init(id: 2, items: [
      .init(identity: "냄비/S", title: "냄비", size: "S", isFavorite: false),
      .init(identity: "냄비/M", title: "냄비", size: "M", isFavorite: false),
      .init(identity: "냄비/L", title: "냄비", size: "L", isFavorite: false)
    ]),
    
    .init(id: 3, items: [
      .init(identity: "텀블러/S", title: "텀블러", size: "S", isFavorite: false),
      .init(identity: "텀블러/M", title: "텀블러", size: "M", isFavorite: false),
      .init(identity: "텀블러/L", title: "텀블러", size: "L", isFavorite: false)
    ]),
    
    .init(id: 4, items: [
      .init(identity: "보온도시락/S", title: "보온도시락", size: "S", isFavorite: false),
      .init(identity: "보온도시락/M", title: "보온도시락", size: "M", isFavorite: false),
      .init(identity: "보온도시락/L", title: "보온도시락", size: "L", isFavorite: false)
    ]),
    
    .init(id: 5, items: [
      .init(identity: "프라이팬/S", title: "프라이팬", size: "S", isFavorite: false),
      .init(identity: "프라이팬/M", title: "프라이팬", size: "M", isFavorite: false),
      .init(identity: "프라이팬/L", title: "프라이팬", size: "L", isFavorite: false)
    ]),
  ]
  
  
}


