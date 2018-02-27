//
//  MineViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/23.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol MineViewControllerLayout {}

enum SelectHeaderMenuBarItemType {
    case topic
    case collect
    case comment
    case viewhistory
}

class MineViewTableNodeHeader: NSObject {
    var containerBox: UIView
    var userAvatar: UIImageView!
    var addressLabel: UILabel!
    var nickNameLabel: UILabel!
    var infoLabel: UILabel!
    var actionButton: UIButton!
    var bottomBar: MineTableNodeHeaderMenuBar
    var selectItemType: SelectHeaderMenuBarItemType = .topic
    init(container: UIView, bar: MineTableNodeHeaderMenuBar) {
        self.containerBox = container
        self.bottomBar = bar
        super.init()
    }
}
protocol MineViewTableNodeHeaderLayout {
    var tableNodeHeader: MineViewTableNodeHeader { get }
    func handleClickHeaderMenuBarItem(sender: UIButton)
}
extension MineViewTableNodeHeaderLayout where Self: MineViewController {
    var tableNodeHeaderBounds: CGRect {
        return CGRect.init(origin: CGPoint.zero,
                           size: CGSize.init(width: self.window_width, height: 328))
    }
    
    func makeTableNodeHeader() -> MineViewTableNodeHeader {
        
        let containerBox: UIView = UIView().then {
            $0.backgroundColor = UIColor.hexColor(hex: "ffffff")
        }
        
        let userAvatar: UIImageView = UIImageView().then {
            containerBox.addSubview($0)
            $0.layer.cornerRadius = 50
            $0.layer.masksToBounds = true
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(0)
                make.centerX.equalTo(containerBox.snp.centerX)
                make.width.height.equalTo(100)
            })
        }
        
        let addressLabel: UILabel = UILabel().then {
            $0.text = "北京，中国"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = Color.color9
            containerBox.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(userAvatar.snp.centerX)
                make.top.equalTo(userAvatar.snp.bottom).offset(15)
            })
        }
        
        UIImageView().do {
            containerBox.addSubview($0)
            $0.image = UIImage.init(named: "ming_address")
            $0.snp.makeConstraints({ (make) in
                make.width.height.equalTo(15)
                make.centerY.equalTo(addressLabel.snp.centerY)
                make.right.equalTo(addressLabel.snp.left).offset(-5)
            })
        }
        
        let nickNameLabel: UILabel = UILabel().then {
            $0.text = "灵活的胖纸"
            $0.textColor = UIColor.white
            containerBox.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(addressLabel.snp.centerX)
                make.top.equalTo(addressLabel.snp.bottom).offset(20)
            })
        }
        
        let nickNameBackground: UIView = UIView().then {
            containerBox.addSubview($0)
            $0.layer.cornerRadius = 15
            $0.backgroundColor = UIColor.pink
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(nickNameLabel.snp.left).offset(-20)
                make.right.equalTo(nickNameLabel.snp.right).offset(20)
                make.centerY.equalTo(nickNameLabel.snp.centerY)
                make.height.equalTo(30)
            })
            containerBox.bringSubview(toFront: nickNameLabel)
        }
        
        let infoLabel: UILabel = UILabel().then {
            containerBox.addSubview($0)
            $0.text = "0粉丝 | 0关注"
            $0.textColor = Color.color6
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(addressLabel.snp.centerX)
                make.top.equalTo(nickNameBackground.snp.bottom).offset(15)
            })
        }
        
        let menuBar: MineTableNodeHeaderMenuBar = MineTableNodeHeaderMenuBar().then {
            containerBox.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(infoLabel.snp.bottom).offset(30)
                make.height.equalTo(70)
                make.left.right.equalTo(0)
            })
            $0.addItemTarget(target: self, action: #selector(self.handleClickHeaderMenuBarItem(sender:)))
        }
        
        UIView().do {
            containerBox.addSubview($0)
            $0.backgroundColor = Color.defaultBGColor
            $0.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(menuBar.snp.bottom)
                make.height.equalTo(20)
            })
        }
        
        let actionButton: UIButton = UIButton.init(type: .custom).then {
            containerBox.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(0)
                make.bottom.equalTo(-90)
            })
        }
        
        return MineViewTableNodeHeader.init(container: containerBox, bar: menuBar).then {
            $0.userAvatar = userAvatar
            $0.addressLabel = addressLabel
            $0.nickNameLabel = nickNameLabel
            $0.infoLabel = infoLabel
            $0.actionButton = actionButton
        }
    }
}

class MineTableNodeHeaderMenuBar: BaseView {
    
    lazy var topicItem: UIButton = {
        return UIButton.init(type: UIButtonType.custom).then {
            self.addSubview($0)
        }
    }()
    
    lazy var collectItem: UIButton = {
        return UIButton.init(type: UIButtonType.custom).then {
            self.addSubview($0)
        }
    }()

    lazy var commentItem: UIButton = {
        return UIButton.init(type: UIButtonType.custom).then {
            self.addSubview($0)
        }
    }()

    lazy var viewHistoryItem: UIButton = {
        return UIButton.init(type: UIButtonType.custom).then {
            self.addSubview($0)
        }
    }()
    
    private var items: [UIButton] {
        return [
            self.topicItem,
            self.collectItem,
            self.commentItem,
            self.viewHistoryItem]
    }
    
    override func setupSubViews() {
        
        UIView().do {
            self.addSubview($0)
            $0.backgroundColor = Color.lineColor
            $0.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(CGFloat.pix1)
            })
        }
        
        var temp: UIButton? = nil
        for (index, item) in items.enumerated() {
            item.isSelected = false
            item.titleLabel?.numberOfLines = 0
            item.tag = 100 + index
            item.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                if temp == nil {
                    make.left.equalTo(0)
                } else {
                    make.left.equalTo(temp!.snp.right)
                    make.width.equalTo(temp!.snp.width)
                }
                if item == items.last {
                    make.right.equalTo(0)
                }
            })
            temp = item
            item.addTarget(self, action: #selector(self.handleClickItem(sender:)),
                           for: UIControlEvents.touchUpInside)
        }
        
        items.first?.isSelected = true
    }
    
    private weak var target: AnyObject? = nil
    private var action: Selector? = nil
    public func addItemTarget(target: AnyObject?, action: Selector?) {
        self.target = target
        self.action = action
    }
    
    @objc private func handleClickItem(sender: UIButton) {
        items.forEach { (item) in
            item.isSelected = false
        }
        sender.isSelected = true
        if self.target != nil &&
            self.action != nil &&
            self.target!.responds(to: self.action) {
            
            self.target?.performSelector(onMainThread: self.action!, with: sender, waitUntilDone: true)
        }
    }
    
    private var titleStyle: ParagraphStyle {
        return NSMutableParagraphStyle().then {
            $0.alignment = .center
            $0.lineSpacing = 10
        }
    }
    
    func setItemCountText(itemIndex: UInt, countText: String) {
        switch itemIndex {
        case 0:
            self.topicItem.setAttributedTitle(buildNormalAttributeText(countText: countText, title: "话题"),
                                              for: UIControlState.normal)
            self.topicItem.setAttributedTitle(buildSelectedAttributeText(countText: countText, title: "话题"),
                                              for: UIControlState.selected)
        case 1:
            self.collectItem.setAttributedTitle(buildNormalAttributeText(countText: countText, title: "收藏"),
                                                for: UIControlState.normal)
            self.collectItem.setAttributedTitle(buildSelectedAttributeText(countText: countText, title: "收藏"),
                                                for: UIControlState.selected)

        case 2:
            self.commentItem.setAttributedTitle(buildNormalAttributeText(countText: countText, title: "评论"),
                                                for: UIControlState.normal)
            self.commentItem.setAttributedTitle(buildSelectedAttributeText(countText: countText, title: "评论"),
                                                for: UIControlState.selected)

        case 3:
            self.viewHistoryItem.setAttributedTitle(buildNormalAttributeText(countText: countText, title: "看过"),
                                                    for: UIControlState.normal)
            self.viewHistoryItem.setAttributedTitle(buildSelectedAttributeText(countText: countText, title: "看过"),
                                                    for: UIControlState.selected)
        default:
            break
        }
    }
    
    private func buildNormalAttributeText(countText: String, title: String) -> NSAttributedString {
        let attrText = countText.withFont(UIFont.boldSystemFont(ofSize: 20))
            .withTextColor(Color.color9) + "\n".attributedString
            + title.withTextColor(Color.color9).withFont(Font.systemFont(ofSize: 11))
        return attrText.withParagraphStyle(self.titleStyle)
    }
    
    private func buildSelectedAttributeText(countText: String, title: String) -> NSAttributedString {
        let attrText = countText.withFont(UIFont.boldSystemFont(ofSize: 20))
            .withTextColor(Color.color3) + "\n".attributedString
            + title.withTextColor(Color.color6).withFont(Font.systemFont(ofSize: 11))
        return attrText.withParagraphStyle(self.titleStyle)
    }
}



