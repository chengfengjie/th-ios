//
//  BaseViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, CustomNavigationBarProtocol {
    
    let content: UIView = UIView.init()

    var customeNavBar: CustomNavBar? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.content)
        self.content.frame = self.view.bounds
        
        self.setNavigationBarHidden(isHidden: false)
    }
    
    func setupSubviews() {}
    
    func setNavigationBarHidden(isHidden: Bool) {
        if isHidden {
            self.customeNavBar?.navBarBox.removeFromSuperview()
            self.customeNavBar = nil
        } else {
            self.customeNavBar = self.addCustomNavigationBar()
        }
    }
    
    func setNavigationBarCloseItem(isHidden: Bool) {
        if self.customeNavBar?.closeItem != nil {
            return
        }
        if isHidden {
            self.customeNavBar?.closeItem?.removeFromSuperview()
        } else {
            self.addNavigationBarLeftIconItem(iconName: "th_close")?.do({ (item) in
                item.addTarget(
                    self, action: #selector(self.navigationBarCloseItemClick),
                    for: UIControlEvents.touchUpInside)
                self.customeNavBar?.closeItem = item
            })
        }
    }
    
    @objc func navigationBarCloseItemClick() {
        self.popViewController(animated: true)
    }
}

/// 获取根控制器协议，UIViewController， UIView 可直接获取
protocol RootNavigationControllerProtocol {}
extension UIResponder: RootNavigationControllerProtocol {}
extension RootNavigationControllerProtocol {
    var rootNavigationController: UINavigationController? {
        return AppDelegate.rootNavgationController;
    }
    func pushViewController(viewController: UIViewController, animated: Bool = true) {
        self.rootNavigationController?.pushViewController(viewController, animated: animated)
    }
    func popViewController(animated: Bool) {
        self.rootNavigationController?.popViewController(animated: animated)
    }
}

extension UIViewController {
}

struct CustomNavBar {
    var navBarBox: UIView
    var navBarContent: UIView
    var closeItem: UIButton? = nil
    init(navBarBox: UIView, barContent: UIView) {
        self.navBarContent = barContent
        self.navBarBox = navBarBox
    }
}

protocol CustomNavigationBarProtocol: SizeUtil {
    var customeNavBar: CustomNavBar? { get set }
}
extension CustomNavigationBarProtocol where Self: UIViewController {
    
    var navBarItemInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func addCustomNavigationBar() -> CustomNavBar {
        if self.customeNavBar != nil {
            return self.customeNavBar!
        }
        let navBar: UIView = UIView.init().then {
            self.view.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(self.height_navBar)
            })
            $0.backgroundColor = UIColor.white
        }
        
        let contentOffset: Float = UIDevice.current.is_iPhoneX ? 0 : -5
        let navBarContent: UIView = UIView.init().then {
            navBar.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.top.equalTo(self.height_statusBar).offset(contentOffset)
            })
        }
        return CustomNavBar.init(navBarBox: navBar, barContent: navBarContent)
    }
    
    @discardableResult
    func addNavigationBarLeftIconItem(iconName: String) -> UIButton? {
        if self.customeNavBar == nil {
            return nil
        }
        return UIButton.init(type: UIButtonType.custom).then({ (item) in
            self.customeNavBar!.navBarContent.addSubview(item)
            item.setImage(UIImage.init(named: iconName), for: UIControlState.normal)
            item.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
            item.snp.makeConstraints({ (make) in
                make.left.top.bottom.equalTo(0)
                make.width.equalTo(self.customeNavBar!.navBarContent.snp.height)
            })
        })
    }
    
    
    /// 给导航栏的左侧添加一个icon+文字的图标按钮，返回三个结构
    ///
    /// - Parameters:
    ///   - iconName: 图片名称
    ///   - title: 标题
    /// - Returns: 返回图片view，label，button
    @discardableResult
    func addNavigationBarLeftIconTextItem(iconName: String, title: String) -> (UIImageView, UILabel, UIButton)? {
        if self.customeNavBar == nil {
            return nil
        }
        let contentBar = self.customeNavBar!.navBarContent
        let icon = UIImageView.init().then { (image) in
            image.image = UIImage.init(named: iconName)
            contentBar.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.left.equalTo(self.navBarItemInset.left)
                make.centerY.equalTo(contentBar.snp.centerY)
                make.width.height.equalTo(16)
            })
        }
        
        let label = UILabel.init().then { (l) in
            l.text = title
            l.textColor = UIColor.color9
            l.font = UIFont.systemFont(ofSize: 12)
            contentBar.addSubview(l)
            l.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.right).offset(5)
                make.centerY.equalTo(icon.snp.centerY)
            })
        }
        
        let btn = UIButton.init(type: .custom).then { (b) in
            contentBar.addSubview(b)
            b.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.left)
                make.right.equalTo(label.snp.right)
                make.top.equalTo(icon.snp.top)
                make.bottom.equalTo(icon.snp.bottom)
            })
        }
        return (icon, label, btn)
    }
    
    
    /// 给自定义导航栏添加一个icon+文字的图标按钮，返回布局控件
    ///
    /// - Parameters:
    ///   - iconName: 图片名称
    ///   - title: title
    /// - Returns: 返回imageView, label, button
    @discardableResult
    func addNavigationBarRightIconTextItem(iconName: String, title: String) -> (UIImageView, UILabel, UIButton)? {
        if self.customeNavBar == nil {
            return nil
        }
        
        let contentBar: UIView = self.customeNavBar!.navBarContent
        
        let label = UILabel.init().then { (l) in
            l.text = title
            l.textColor = UIColor.color9
            l.font = UIFont.systemFont(ofSize: 12)
            contentBar.addSubview(l)
            l.snp.makeConstraints({ (make) in
                make.right.equalTo(-self.navBarItemInset.right)
                make.centerY.equalTo(contentBar.snp.centerY)
            })
        }
        
        let icon = UIImageView.init().then { (image) in
            image.image = UIImage.init(named: iconName)
            contentBar.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.right.equalTo(label.snp.left).offset(-5)
                make.centerY.equalTo(label.snp.centerY)
                make.width.height.equalTo(16)
            })
        }
        
        let btn = UIButton.init(type: UIButtonType.custom).then { (b) in
            contentBar.addSubview(b)
            b.snp.makeConstraints({ (make) in
                make.right.equalTo(label.snp.right)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.left.equalTo(icon.snp.left)
            })
        }
        
        return (icon, label, btn)
    }
    
}
