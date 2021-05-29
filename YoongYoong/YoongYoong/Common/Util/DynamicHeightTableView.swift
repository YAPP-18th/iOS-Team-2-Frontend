//
//  DynamicHeightTableView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit

class DynamicHeightTableView: UITableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
     }

    override var intrinsicContentSize: CGSize {

        return contentSize
    }
}
