//
//  SameCityMainViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class SameCityMainViewController: BaseViewController<SameCityMainViewModel>,
    BaseTabBarItemConfig,
    MagicControllerContainerProtocol {
    
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
        
        self.bindViewModel()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
                
        viewModel.cateDataProperty.signal.observeValues { [weak self] (_) in
            self?.vtMagicController.magicView.reloadData()
        }
        
        viewModel.selectCityAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SelectCityViewController(viewModel: model))
        }
        
        navBarSearchItem.reactive.pressed = CocoaAction(viewModel.searchAction)
        viewModel.searchAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SearchViewController(viewModel: model))
        }

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
            l.reactive.text <~ self.viewModel.currentUser.currentCityName
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
        viewModel.selectCityAction.apply(()).start()
    }
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return self.viewModel.cateTitles
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        return self.magicViewDequeueReusableItem(magicView: magicView, itemIndex: itemIndex)
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: "identifer")
        if controller == nil {
            let model = self.viewModel.getSameCityViewModel(cateIndex: pageIndex.int)
            controller = SameCityViewController(viewModel: model)
        }
        return controller!
    }
}
