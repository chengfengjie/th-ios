//
//  MessageListViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

protocol MessageListViewLayout {
    var headerChangeControl: HeaderChangeControl { get }
}
extension MessageListViewLayout where Self: MessageListViewController {
    var headerChangeControlSize: CGSize {
        return CGSize.init(width: self.window_width, height: 45)
    }
    func makeHeaderChangeControl() -> HeaderChangeControl {
        return HeaderChangeControl().then {
            $0.titles = ["系统", "私信"]
            $0.bottomlineWidth = self.window_width / 2 - 30
            $0.frame = CGRect.init(origin: CGPoint.zero, size: self.headerChangeControlSize)
        }
    }
}
