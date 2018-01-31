//
//  SameCityMainViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityMainViewController: BaseViewController,
    BaseTabBarItemConfig,
    MagicControllerContainerProtocol,
    NavBarSearchItemProtocol {
    
    lazy var vtMagicController: VTMagicController = {
        return self.createMagicController()
    }()
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "同城"
            $0.iconName = "tabbar_city_normal"
            $0.selectedIconName = "tabbar_city_select"
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.layoutMagicController()
        
        self.setNavigationBarPositionItem()
        
        self.makeNavigationBarSearchItem()
    }
    
    private func setNavigationBarPositionItem() {
        
        let contentBar: UIView = self.customeNavBar.navBarContent
        let icon = UIImageView.init().then { (item) in
            item.image = UIImage.init(named: "city_position")
            contentBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.centerY.equalTo(contentBar.snp.centerY)
                make.width.height.equalTo(14)
            })
        }
        
        let label: UILabel = UILabel().then { (l) in
            l.text = "广州"
            l.font = UIFont.songTi(size: 16)
            contentBar.addSubview(l)
            l.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.right).offset(6)
                make.centerY.equalTo(icon.snp.centerY)
            })
        }
        
        UIImageView().do { (item) in
            item.image = UIImage.init(named: "city_codwn_indicator")
            contentBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(label.snp.right).offset(3)
                make.width.height.equalTo(10)
                make.centerY.equalTo(label.snp.centerY)
            })
        }
        
        UIButton.init(type: UIButtonType.custom).do {
            contentBar.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.left)
                make.right.equalTo(label.snp.right).offset(20)
                make.centerY.equalTo(label.snp.centerY)
                make.height.equalTo(40)
            })
            $0.addTarget(self, action: #selector(self.handleClickCityItem),
                         for: UIControlEvents.touchUpInside)
        }
    }
    
    @objc func handleClickCityItem() {
        self.pushViewController(viewController: SelectCityViewController(style: .grouped))
    }
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["推荐", "亲子活动", "新鲜事儿", "教育信息", "周边游", "打折信息"]
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        return self.magicViewDequeueReusableItem(magicView: magicView, itemIndex: itemIndex)
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let identifer: String = "identifer";
        var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: identifer)
        if controller == nil {
            controller = SameCityViewController(style: UITableViewStyle.grouped)
        }
        return controller!
    }
}
