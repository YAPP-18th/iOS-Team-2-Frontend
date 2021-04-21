//
//  Identifiable.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/21.
//

import Foundation
import UIKit

protocol Identifiable {
  static var identifier: String { get }
}

extension Identifiable {
  static var identifier: String {
    return String(describing: self)
  }
}
//identifier를 자동으로 만들어줍니다.
extension UITableViewCell: Identifiable {}
extension UICollectionViewCell: Identifiable {}
extension UIViewController: Identifiable {}
