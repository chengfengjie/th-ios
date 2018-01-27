//
//  NavigationBarProtocol.swift
//  th-ios
//
//  Created by chengfj on 2018/1/19.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct CustomNavBar {
    var navBarBox: UIView
    var navBarContent: UIView
    var closeItem: UIButton? = nil
    var titleLabel: UILabel? = nil
    init(navBarBox: UIView, barContent: UIView) {
        self.navBarContent = barContent
        self.navBarBox = navBarBox
    }
}

/// 自定义导航栏的协议，控制器需要自定义导航栏只需要遵循此协议就有了自定义导航栏的能力
protocol CustomNavigationBarProtocol: SizeUtil {
    var customeNavBar: CustomNavBar { get }
}
extension CustomNavigationBarProtocol where Self: UIViewController {
    
    var navBarItemInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    /// 创建导航栏
    ///
    /// - Returns: 导航栏结构
    func makeCustomNavigationBar() -> CustomNavBar {
        let navBar: UIView = UIView.init().then {
            self.view.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(self.height_navBar)
            })
            $0.backgroundColor = UIColor.white
        }
        
        let navBarContent: UIView = UIView.init().then {
            navBar.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.top.equalTo(self.height_statusBar)
            })
        }
        return CustomNavBar.init(navBarBox: navBar, barContent: navBarContent)
    }
    
    
    /// 创建导航栏左侧图标按钮
    ///
    /// - Parameter iconName: 图标图片名称
    /// - Returns: 按钮
    @discardableResult
    func makeNavBarLeftIconItem(iconName: String) -> UIButton {
        return UIButton.init(type: UIButtonType.custom).then({ (item) in
            self.customeNavBar.navBarContent.addSubview(item)
            item.setImage(UIImage.init(named: iconName), for: UIControlState.normal)
            item.imageEdgeInsets = UIEdgeInsets.init(top: 15, left: 20, bottom: 15, right: 10)
            item.snp.makeConstraints({ (make) in
                make.left.top.bottom.equalTo(0)
                make.width.equalTo(self.customeNavBar.navBarContent.snp.height)
            })
        })
    }
    
    
    /// 创建navigationBar右侧的按钮
    ///
    /// - Parameter iconName: 按钮图片名
    /// - Returns: 按钮
    @discardableResult
    func makeNavBarRightIconItem(iconName: String) -> UIButton {
        let navBarContent: UIView = self.customeNavBar.navBarContent
        return UIButton.init(type: .custom).then({ (item) in
            navBarContent.addSubview(item)
            item.setImage(UIImage.init(named: iconName), for: .normal)
            item.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
            item.snp.makeConstraints({ (make) in
                make.right.top.bottom.equalTo(0)
                make.width.equalTo(navBarContent.snp.height)
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
    func makeNavBarLeftIconTextItem(iconName: String, title: String) -> (UIImageView, UILabel, UIButton) {
        let contentBar = self.customeNavBar.navBarContent
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
    func makeNavBarRightIconTextItem(iconName: String, title: String) -> (UIImageView, UILabel, UIButton) {
        let contentBar: UIView = self.customeNavBar.navBarContent
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
    
    
    /// 构建导航栏标题
    ///
    /// - Parameter attributeText: 标题名称
    /// - Returns: label
    @discardableResult
    func makeNavBarAttributeTitle(attributeText: NSAttributedString) -> UILabel {
        let contentBar: UIView = self.customeNavBar.navBarContent
        return UILabel().then {
            contentBar.addSubview($0)
            $0.attributedText = attributeText
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(contentBar.snp.centerX)
                make.centerY.equalTo(contentBar.snp.centerY)
            })
        }
    }
    
    @discardableResult
    func makeNavBarBottomline() -> UIView {
        let contentBar: UIView = self.customeNavBar.navBarContent
        return UIView().then {
            $0.backgroundColor = UIColor.lineColor
            contentBar.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(1)
            })
        }
    }
    
}


