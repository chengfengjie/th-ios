//
//  HomeViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController,
    BaseTabBarItemConfig,
    MagicControllerContainerProtocol,
    HomeViewControllerLayout,
    NavBarSearchItemProtocol {
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "首页"
            $0.iconName = "tabbar_home_normal"
            $0.selectedIconName = "tabbar_home_select"
        }
    }()
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()

    lazy var vtMagicController: VTMagicController = {
        return self.createMagicController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutMagicController()
        
        self.makeNavigationBarLogo()
        
        self.makeNavigationBarSearchItem()
        
        self.bind()
    }
    
    func bind() {
        
        self.viewModel.reactive
            .signal(forKeyPath: "cateData")
            .skipNil()
            .observeValues { [weak self] (val) in
                self?.vtMagicController.magicView.reloadData()
        }
    }
    
    @objc func handleNavigationBarSearchItemClick() {
        
    }
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return self.viewModel.cateData.map({ (val) -> String in
            return (val as! JSON)["catname"].stringValue
        })
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        return self.magicViewDequeueReusableItem(magicView: magicView, itemIndex: itemIndex)
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let index: Int = Int(pageIndex)
        let dataJSON: JSON = self.viewModel.cateData[index] as! JSON
        if dataJSON["catid"].intValue == 0 {
            let identifer: String = "headlineIdentifer_\(pageIndex)"
            var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: identifer)
            if controller == nil {
                controller = HeadlineViewController.init(cateInfo: dataJSON)
            }
            return controller!
        } else {
            let identifer: String = "categoryIdentifer_\(pageIndex)"
            var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: identifer)
            if controller == nil {
                controller = HomeCategoryViewController(style: UITableViewStyle.grouped)
            }
            return controller!
        }
    }
}

extension HomeViewController {
    static let kLogoImage: UIImage? = UIImage.init(named: "home_logo")
    var logoImage: UIImage? {
        return HomeViewController.kLogoImage
    }
    var logoSize: CGSize {
        if self.logoImage == nil {
            return CGSize.zero
        } else {
            let size: CGSize = self.logoImage!.size
            let height: CGFloat = 16.0
            let widht = height * size.width / size.height
            return CGSize.init(width: widht, height: height)
        }
    }
}

protocol HomeViewControllerLayout {
}
extension HomeViewControllerLayout where Self: HomeViewController {
    func makeNavigationBarLogo() {
        let navBarContent: UIView = self.customeNavBar.navBarContent
        UIImageView.init().do { (icon) in
            icon.image = self.logoImage
            navBarContent.addSubview(icon)
            icon.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.centerY.equalTo(navBarContent.snp.centerY)
                make.height.equalTo(self.logoSize.height)
                make.width.equalTo(self.logoSize.width)
            })
        }
    }
}
