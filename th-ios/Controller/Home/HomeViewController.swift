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
    HomeViewControllerLayout {
    
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
        
        viewModel.cateDataProperty.signal.observeValues { [weak self] (_) in
            self?.vtMagicController.magicView.reloadData()
        }
        
        navBarSearchItem.reactive.pressed = CocoaAction(viewModel.searchAction)
        viewModel.searchAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SearchViewController(viewModel: model))
        }
        
    }
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["推荐"] + self.viewModel.cateDataProperty.value.map { $0["labelName"].stringValue }
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        return self.magicViewDequeueReusableItem(magicView: magicView, itemIndex: itemIndex)
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let model = self.viewModel.createHomeArticleViewModel(cateIndex: pageIndex.int)
        var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: headlineIdentifer + pageIndex.description)
        if controller == nil {
            controller = HeadlineViewController(viewModel: model)
        }
        return controller!
    }
    
    func magicView(_ magicView: VTMagicView, itemWidthAt itemIndex: UInt) -> CGFloat {
        let titles = self.menuTitles(for: self.vtMagicController.magicView)
        let text: NSString = titles[itemIndex.int] as NSString
        let width = text.size(withAttributes: [NSAttributedStringKey.font : UIFont.sys(size: 16)]).width + 20
        return width + 10
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
