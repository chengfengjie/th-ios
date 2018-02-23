//
//  HomeViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController<HomeViewModel>,
    BaseTabBarItemConfig,
    MagicControllerContainerProtocol,
    HomeViewControllerLayout,
    NavBarSearchItemProtocol {
    
    private let headlineIdentifer = "headlineIdentifer"
    private let categoryIdentifer = "categoryIdentifer"
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "首页"
            $0.iconName = "tabbar_home_normal"
            $0.selectedIconName = "tabbar_home_select"
        }
    }()
    
    lazy var vtMagicController: VTMagicController = {
        return self.createMagicController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutMagicController()
        
        self.makeNavigationBarLogo()
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.cateDataProperty.signal.observeValues { [weak self] (_) in
            self?.vtMagicController.magicView.reloadData()
        }
    }
    
    func bind() {

    }
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return self.viewModel.cateDataProperty.value.map { $0["catname"].stringValue }
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        return self.magicViewDequeueReusableItem(magicView: magicView, itemIndex: itemIndex)
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let dataJSON: JSON = self.viewModel.cateDataProperty.value[pageIndex.int]

        if dataJSON["catid"].intValue == 0 {
            var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: headlineIdentifer)
            if controller == nil {
                let model = self.viewModel.createHomeArticleViewModel(cateIndex: pageIndex.int)
                controller = HeadlineViewController(viewModel: model)
            }
            return controller!
        } else {
            var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: categoryIdentifer)
            if controller == nil {
                let model = self.viewModel.createHomeArticleViewModel(cateIndex: pageIndex.int)
                controller = HomeCategoryViewController(viewModel: model)
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
