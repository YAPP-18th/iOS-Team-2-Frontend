//
//  Post.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/27.
//

import Foundation
import Photos

class PostData {
  static let shared = PostData()
  
  var containers: [PostContainer]?
  var postImages: [PHAsset]?
  var reviewBadges: String?
  var content: String?
  var place: Place?
  
  private init() {}
  
  func toDTO(_ completion: @escaping (PostRequestDTO) -> () ) {
    var containersDTO = [PostContainerDTO]()
    
    for container in containers! {
      containersDTO.append(PostContainerDTO(container: ContainerDTO(name: container.containerData.name,
                                                                    size: container.containerData.size),
                                            containerCount: container.containerCount,
                                            food: container.food,
                                            foodCount: container.foodCount) )
    }
    
    // assets.forEach -> requestImage(async) -> 모든 요청이 완료되면 -> return [Data]
    assetToData(postImages!) { [weak self] in
      guard let self = self else { return }
      completion(PostRequestDTO(postImages: $0,
                                content: self.content ?? "",
                                placeLocation: self.place!.address,
                                placeName: self.place!.name,
                                containers: containersDTO,
                                reviewBadge: self.reviewBadges!))
      
    }
        
  }
  
  
  private func assetToData(_ assets: [PHAsset], _ completion: @escaping ([Data]) -> ()) {
    var datas = [Data]()
    let dispatchGroup = DispatchGroup()
    assets.forEach { asset in
      let options = PHImageRequestOptions()
      options.isNetworkAccessAllowed = true
      
      dispatchGroup.enter()
      // async
      PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options) { image, _ in

      if let image = image, let data = image.jpegData(compressionQuality: 1.0) {
        datas.append(data)
        dispatchGroup.leave()
      }
      
    }}
      
    dispatchGroup.notify(queue: .main) {
      completion(datas)
    }
  }
  
}

struct PostContainer {
  let containerData: ContainerData
  let containerCount: Int
  let food: String
  let foodCount: Int
}

struct ContainerData {
  let name: String
  let size: String
}
