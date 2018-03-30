//
//  ShareViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/3/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct ShareViewElements {
    var mainBox: UIView!
    var shareItems: [UIButton] = []
}

protocol ShareViewLayout {
    var element: ShareViewElements { get }
    var content: UIView { get }
}
extension ShareViewLayout where Self: UIViewController {
    
    var shareItems: [[String: String]] {
        return [
            ["name": "微信", "icon": "share_menu_wechat"],
            ["name": "朋友圈", "icon": "share_menu_friend"],
            ["name": "QQ", "icon": "share_menu_qq"],
            ["name": "复制", "icon": "share_menu_copy"],
            ["name": "更多", "icon": "share_menu_more"]
        ]
    }
    
    private var mainBoxHeight: CGFloat {
        return 280
    }
    
    private var mainBoxFrame: CGRect {
        return CGRect.init().with({ (rect) in
            rect.origin.x = 0
            rect.origin.y = self.view.frame.height - self.mainBoxHeight
            rect.size.width = self.view.frame.width
            rect.size.height = self.mainBoxHeight
        })
    }
    
    func layoutSubviews() -> ShareViewElements {
        
        self.content.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        
        var element = ShareViewElements()
        
        element.mainBox = UIView().then({ (box) in
            self.content.addSubview(box)
            var frame = self.mainBoxFrame
            frame.origin.y = self.view.frame.height
            box.frame = frame
        })
        
       UILabel().do { (label) in
            element.mainBox.addSubview(label)
            label.text = "分享到"
            label.font = UIFont.sys(size: 14)
            label.snp.makeConstraints({ (make) in
                make.height.equalTo(60)
                make.centerX.equalTo(element.mainBox.snp.centerX)
                make.top.equalTo(0)
            })
        }
        
        let width = self.view.frame.width / 3.0
        var frame = CGRect.init(x: 0, y: 70, width: width, height: 100)
        var index: Int = 1
        shareItems.forEach { (item) in
            let shareItem: UIButton = UIButton.init(type: .custom)
            element.shareItems.append(shareItem)
            shareItem.frame = frame
            shareItem.tag = index
            element.mainBox.addSubview(shareItem)
            self.createShareItem(view: shareItem, item: item)
            frame.origin.x = frame.origin.x + frame.width
            if index % 3 == 0 {
                frame.origin.x = 0
                frame.origin.y = frame.origin.y + frame.height
            }
            index = index + 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.showAnimate()
        }
        
        return element
    }
    
    private func createShareItem(view: UIButton, item: [String: String]) {
        
        let icon: UIImageView = UIImageView()
        icon.image = UIImage.init(named: item["icon"]!)
        view.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(0)
            make.width.height.equalTo(40)
        }
        
        UILabel.init().do { (label) in
            view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(icon.snp.bottom).offset(10)
                make.centerX.equalTo(icon.snp.centerX)
            })
            label.text = item["name"]
            label.font = UIFont.sys(size: 14)
            label.textColor = UIColor.color3
        }
    }
    
    private func showAnimate() {
        UIView.animate(withDuration: 0.5) {
            self.element.mainBox.frame = self.mainBoxFrame
        }
    }
}
