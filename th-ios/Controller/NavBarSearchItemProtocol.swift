//
//  NavBarSearchItemProtocol.swift
//  th-ios
//
//  Created by chengfj on 2018/1/20.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol NavBarSearchItemProtocol {}
extension NavBarSearchItemProtocol where Self: BaseViewController {
    func makeNavigationBarSearchItem() {
        self.makeNavBarRightIconItem(iconName: "city_search")
            .then({ (item) in
                item.imageEdgeInsets = UIEdgeInsets.init(top: 15, left: 5, bottom: 15, right: 25)
        }).reactive.controlEvents(.touchUpInside)
            .observe { [weak self] (signal) in
                self?.pushViewController(viewController: SearchViewController())
        }
    }
}
