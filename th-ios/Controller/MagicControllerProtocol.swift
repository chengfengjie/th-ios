//
//  MagicControllerProtocol.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import UIKit

/// 使用VTMagicController布局需要用到的size
protocol MagicLayoutSize: SizeUtil {}
extension MagicLayoutSize {
    
    /// 使用VTMagicController的时候装VTMagicController的view的容器高度
    ///
    /// - Parameters:
    ///   - existNavBar: container控制器是否存在navBar，如果存在，需要减去navBar的高度
    ///   - existTabBar: container控制器是否存在tabBar，如果存在，需要减去tabBar的高度
    /// - Returns: container的高度
    func magicControllerContainerHeight(existNavBar:Bool = true, existTabBar: Bool = true) -> CGFloat {
        let height: CGFloat = UIScreen.main.bounds.height
        let navBarHeight: CGFloat = existNavBar ? self.height_navBar.cgFloat : 0.0
        let tabBarHeight: CGFloat = existTabBar ? self.height_tabBar.cgFloat : 0.0
        return height - navBarHeight - tabBarHeight
    }
    
    
    /// VTMagicController包含的控制器的content的高度，需要减去headerBar的高度，默认44.0
    ///
    /// - Parameters:
    ///   - existNavBar: container控制器是否存在navBar，如果存在，需要减去navBar的高度
    ///   - existTabBar: container控制器是否存在tabBar，如果存在，需要减去tabBar的高度
    /// - Returns: VTMagicController 包含的控制器的content高度
    func magicControllerContentHeihgt(existNavBar:Bool = true, existTabBar: Bool = true) -> CGFloat {
        let height: CGFloat = UIScreen.main.bounds.height
        let changeBarHeight: CGFloat = 44.0
        let navBarHeight: CGFloat = existNavBar ? self.height_navBar.cgFloat : 0.0
        let tabBarHeight: CGFloat = existTabBar ? self.height_tabBar.cgFloat : 0.0
        return height - navBarHeight - tabBarHeight - changeBarHeight
    }
}

/// 需要使用VTMagicController的控制器遵循此协议，如果继承自BaseViewController，可以调用布局方法
protocol MagicControllerContainerProtocol: VTMagicViewDataSource, VTMagicViewDelegate, MagicLayoutSize {
    var vtMagicController: VTMagicController { get }
}

// MARK: - BaseViewController布局VTMagicController的方法
// 先调用createMagicController创建controller赋值给vtMagicController
// 再调用 layoutMagicController 完成布局
extension MagicControllerContainerProtocol where Self: BaseViewController {
    
    func createMagicController() -> VTMagicController {
        return VTMagicController.init().then({
            $0.magicView.navigationColor = UIColor.white
            $0.magicView.sliderColor = UIColor.red
            $0.magicView.layoutStyle = VTLayoutStyle.default
            $0.magicView.switchStyle = VTSwitchStyle.default
            $0.magicView.dataSource = self
            $0.magicView.delegate = self
        })
    }
    
    func layoutMagicController(existNavBar:Bool = true, existTabBar: Bool = true) {
        if self.childViewControllers.contains(self.vtMagicController) {
            return
        }
        UIView.init().do { (main) in
            self.content.addSubview(main)
            main.frame = CGRect.init().with({ (rect) in
                rect.origin.x = 0
                rect.origin.y = self.height_navBar.cgFloat
                rect.size.width = self.view.frame.width
                rect.size.height = magicControllerContainerHeight(existNavBar: existNavBar, existTabBar: existTabBar)
            })
            
            self.addChildViewController(self.vtMagicController)
            main.addSubview(self.vtMagicController.view)
            self.vtMagicController.magicView.reloadData()
        }
    }
    
    func magicViewDequeueReusableItem(
        magicView: VTMagicView,
        itemIndex: UInt,
        identifer: String = "magicItemIdentifer") -> UIButton {
        var menuItem:UIButton? = magicView.dequeueReusableItem(withIdentifier: identifer)
        if menuItem == nil {
            menuItem = UIButton.init(type: .custom)
            menuItem?.setTitleColor(UIColor.color9, for: UIControlState.normal)
            menuItem?.setTitleColor(UIColor.pink, for: UIControlState.selected)
            menuItem?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            menuItem?.backgroundColor = UIColor.white
        }
        return menuItem!

    }
}

/// VTMagicController包含的控制器遵循此协议，处理起子视图的frame
protocol MagicContentLayoutProtocol: MagicLayoutSize {}
/// VTMagicController的子控制器是BaseTableViewController的时候，添加处理tableNode的方法
extension MagicContentLayoutProtocol where Self: BaseTableViewController {
    func setupContentTableNodeLayout(existNavBar:Bool = true, existTabBar: Bool = true) {
        self.tableNode.frame = CGRect.init().with({
            $0.origin.x = 0
            $0.origin.y = 0
            $0.size.width = self.window_width
            $0.size.height = self.magicControllerContentHeihgt(existNavBar: existNavBar, existTabBar: existTabBar)
        })
        self.tableNode.contentInset = UIEdgeInsets.zero
    }
}
