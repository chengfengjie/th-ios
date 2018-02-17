//
//  RootViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class RootViewController: BaseTabBarController<RootViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        
        self.setViewControllers([
            HomeViewController(viewModel: self.viewModel.homeViewModel),
            SameCityMainViewController(viewModel: self.viewModel.sameCityMainViewModel),
            QingViewController(style: .grouped, viewModel: self.viewModel.qingViewModel),
            MineViewController(style: .grouped, viewModel: self.viewModel.mineViewModel)
            ], animated: false)
        
    }

    private func setupSubviews() {
        
        /// 配置底部tabbar 高度在iPhoneX的高度是83 其他设备49
        baseTabBar = BaseTabBar.init(frame: CGRect.zero).then {
            view.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(self.height_tabBar)
            })
        }
        baseTabBar?.addTarget(target: self, action: #selector(self.handleClickBarItem(sender:)))
    }
    
    @objc private func handleClickBarItem(sender: UIButton) {
        if sender.tag == 103 && !UserModel.current.isLogin {
            self.pushViewController(viewController: AuthorizeInputCellphoneController(viewModel: self.viewModel.loginInputPhoneViewModel))
        } else {
            let index = sender.tag - BaseTabBar.ITEM_TAG_OFFSET
            baseTabBar?.imageLabelTuple.forEach({ (item) in
                item.0.isHighlighted = false
                item.1.isHighlighted = false
            })
            baseTabBar?.imageLabelTuple[index].0.isHighlighted = true
            baseTabBar?.imageLabelTuple[index].1.isHighlighted = true
            self.selectedViewController = self.viewControllers?[index]
        }
        
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?,
                                     animated: Bool) {
        
        super.setViewControllers(viewControllers,
                                 animated: animated)
        
        var items: [BaseTabBarItemConfigModel] = []
        
        viewControllers?.forEach({ (item) in
            if item is BaseTabBarItemConfig {
                items.append((item as! BaseTabBarItemConfig).itemConfigModel)
            } else {
                items.append(BaseTabBarItemConfigModel.init(iconName: "", selectedIconName: "", title: ""))
            }
        })
        
        baseTabBar?.updateSubViews(items: items)
    }
}
