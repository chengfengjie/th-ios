//
//  BaseTabBarController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController, SizeUtil {
    
    var baseTabBar: BaseTabBar? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isHidden = true
        
        self.delegate = RZTransitionsManager.shared()
    
        setupSubviews()
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
        let index = sender.tag - BaseTabBar.ITEM_TAG_OFFSET
        baseTabBar?.imageLabelTuple.forEach({ (item) in
            item.0.isHighlighted = false
            item.1.isHighlighted = false
        })
        baseTabBar?.imageLabelTuple[index].0.isHighlighted = true
        baseTabBar?.imageLabelTuple[index].1.isHighlighted = true
        self.selectedViewController = self.viewControllers?[index]
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

class BaseTabBarItemConfigModel: NSObject {
    var selectedIconName: String
    var iconName: String
    var title: String
    init(iconName: String, selectedIconName: String, title: String) {
        self.iconName = iconName
        self.selectedIconName = selectedIconName
        self.title = title
    }
    
    override init() {
        self.iconName = ""
        self.selectedIconName = ""
        self.title = ""
    }
}

protocol BaseTabBarItemConfig {
    var itemConfigModel: BaseTabBarItemConfigModel { get }
}

class BaseTabBar: BaseView, SizeUtil {
    
    static let ITEM_TAG_OFFSET: Int = 100
    
    private var target: Any? = nil
    private var action: Selector? = nil
    func addTarget(target: Any?, action: Selector) {
        self.target = target
        self.action = action
    }
    
    var imageLabelTuple: [(UIImageView, UILabel)] = []
    
    override func setupSubViews() {
        self.backgroundColor = UIColor.white
    }
    
    func updateSubViews(items: [BaseTabBarItemConfigModel]) {
        self.imageLabelTuple.removeAll()
        self.subviews.forEach { $0.removeFromSuperview() }
        
        var btn: UIButton? = nil

        for (index, item) in items.enumerated() {
            
            UIButton.init(type: .custom).do({
                addSubview($0)
                $0.tag = BaseTabBar.ITEM_TAG_OFFSET + index
                $0.setTitleColor(UIColor.blue, for: .normal)
                
                if self.action != nil {
                    $0.addTarget(self.target,
                                 action: self.action!,
                                 for: UIControlEvents.touchUpInside)
                }
                
                $0.snp.makeConstraints({ (make) in
                    make.top.equalTo(0)
                    make.height.equalTo(self.height_tabbarContent)
                    if btn == nil {
                        make.left.equalTo(0)
                    } else {
                        make.left.equalTo(btn!.snp.right)
                        make.width.equalTo(btn!.snp.width)
                    }
                    
                    if index == items.count - 1 {
                        make.right.equalTo(0)
                    }
                })
                
                btn = $0
            })
            
            let icon = UIImageView.init().then({
                btn?.addSubview($0)
                $0.image = UIImage.init(named: item.iconName)
                $0.highlightedImage = UIImage.init(named: item.selectedIconName)
                $0.isHighlighted = index == 0
                $0.snp.makeConstraints({ (make) in
                    make.width.height.equalTo(18)
                    make.top.equalTo(7)
                    make.centerX.equalTo(btn!.snp.centerX)
                })
            })
            
            let text = UILabel.init().then({
                btn?.addSubview($0)
                $0.text = item.title
                $0.textColor = UIColor.gray
                $0.highlightedTextColor = UIColor.pink
                $0.textAlignment = .center
                $0.isHighlighted = index == 0
                $0.font = UIFont.systemFont(ofSize: 10)
                $0.snp.makeConstraints({ (make) in
                    make.left.right.equalTo(0)
                    make.top.equalTo(30)
                })
            })
            self.imageLabelTuple.append((icon, text))
        }
    
    }
}

