//
//  LeaderboardsViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

fileprivate let kContentInset: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)

protocol LeaderboardsViewLayout {
    var headerChangeControl: HeaderChangeControl { get }
}
extension LeaderboardsViewLayout where Self: LeaderboardsViewController {
    var headerChangeControlSize: CGSize {
        return CGSize.init(width: self.window_width, height: 45)
    }
    func makeHeaderChangeControl() -> HeaderChangeControl {
        return HeaderChangeControl().then {
            $0.titles = ["24H热门", "七日热门", "三十日热门"]
            $0.frame = CGRect.init(origin: CGPoint.zero, size: self.headerChangeControlSize)
        }
    }
}


class LeaderboardsViewCellNode: NoneContentArticleCellNodeImpl {

    override init() {
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildNoneImageLayoutSpec(constrainedSize: constrainedSize)
    }
    
}




