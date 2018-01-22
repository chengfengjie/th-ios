//
//  QingViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/22.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

private let kContentInset: UIEdgeInsets = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)

class QingViewTableNodeBannerHeader: NSObject {
    var containerBox: UIView
    init(containerBox: UIView) {
        self.containerBox = containerBox
        super.init()
    }
}

class QingViewTableNodeMenuBarHeader: NSObject {
    var containerBox: UIView
    init(containerBox: UIView) {
        self.containerBox = containerBox
        super.init()
    }
}

protocol QingViewLayout {
    var tableNodeBannerHeader: QingViewTableNodeBannerHeader { get }
    func handleSingnInButtonClick()
    var tableNodeMneuBarHeader: QingViewTableNodeMenuBarHeader { get }
}

extension QingViewLayout where Self: QingViewController {
    
    var contentInset: UIEdgeInsets {
        return kContentInset
    }
    
    var bannerImageSize: CGSize {
        let proportion: CGFloat = 0.5
        let width: CGFloat = self.window_width - self.contentInset.left - self.contentInset.right
        return CGSize.init(width: width, height: width * proportion)
    }
    
    var tableNodeHeaderSize: CGSize {
        return CGSize.init(width: self.window_width, height: self.bannerImageSize.height + 10)
    }
    
    var tableNodeMenuBarHeaderSize: CGSize {
        return CGSize.init(width: self.window_width, height: 60)
    }
    
    func makeNavigationBarLeftChatItem() {
        let barContent: UIView = self.customeNavBar.navBarContent
        
        let icon: UIImageView = UIImageView.init().then {
            $0.image = UIImage.init(named: "qing_message")
            barContent.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.centerY.equalTo(barContent.snp.centerY)
                make.width.height.equalTo(15)
            })
        }
        
        UILabel.init().do {
            $0.text = "Qing聊"
            barContent.addSubview($0)
            $0.font = UIFont.songTiBold(size: 16)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.right).offset(5)
                make.centerY.equalTo(icon.snp.centerY)
            })
        }
    }
    
    func makeQingViewTableNodeHeader() -> QingViewTableNodeBannerHeader {
        let header: UIView = UIView().then {
            $0.frame = CGRect.init(origin: CGPoint.zero, size: self.tableNodeHeaderSize)
        }
        
        let bannerImage: UIImageView = UIImageView.init().then {
            header.addSubview($0)
            $0.yy_imageURL = URL.init(string: "http://a.hiphotos.baidu.com/image/h%3D300/sign=71f6f27f2c7f9e2f6f351b082f31e962/500fd9f9d72a6059f550a1832334349b023bbae3.jpg")
            $0.backgroundColor = UIColor.orange
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(0)
                make.left.equalTo(self.contentInset.left)
                make.right.equalTo(-self.contentInset.right)
                make.height.equalTo(self.bannerImageSize.height)
            })
        }
        
        CAGradientLayer.init().do {
            $0.frame = CGRect.init(origin: CGPoint.init(x: self.contentInset.left, y: 0),
                                   size: self.bannerImageSize)
            $0.colors = [UIColor.white.cgColor, UIColor.init(white: 1, alpha: 0.2).cgColor]
            header.layer.addSublayer($0)
        }
        
        UIButton.init(type: UIButtonType.custom).do {
            $0.setTitle("签", for: UIControlState.normal)
            $0.layer.borderColor = UIColor.hexColor(hex: "919191").cgColor
            $0.setTitleColor(UIColor.color3, for: .normal)
            $0.layer.borderWidth = 1
            header.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.right.equalTo(-self.contentInset.right * 2)
                make.top.equalTo(10)
                make.width.height.equalTo(30)
            })
        }
        
        UILabel.init().do {
            header.addSubview($0)
            $0.text = "09"
            $0.font = UIFont.systemFont(ofSize: 40)
            $0.snp.makeConstraints({ (make) in
                make.bottom.equalTo(bannerImage.snp.bottom).offset(-15)
                make.left.equalTo(bannerImage.snp.left).offset(15)
            })
        }
        
        return QingViewTableNodeBannerHeader.init(containerBox: header)
    }
    
    var menuItemInfo: [(String, String)] {
        return [("最新话题", "qing_the_latest_topic"),
                ("我发表的", "qing_published"),
                ("我参与的", "qing_attended"),
                ("最近浏览", "qing_recently_viewed")]
    }
    
    func makeTopMenuBarHeader() -> QingViewTableNodeMenuBarHeader {
        let header: UIView = UIView.init()
        
        let itemInfo: [(String, String)] = self.menuItemInfo
        
        var tempButton: UIButton? = nil
        for item in itemInfo {
            let showLine: Bool = item.0 != itemInfo.last?.0
            self.createMenuBarItem(title: item.0, iconName: item.1, showRightline: showLine).do {
                header.addSubview($0)
                $0.setTitle(title, for: UIControlState.normal)
                $0.setTitleColor(UIColor.orange, for: UIControlState.normal)
                $0.snp.makeConstraints({ (make) in
                    make.top.bottom.equalTo(0)
                    if tempButton == nil {
                        make.left.equalTo(0)
                    } else {
                        make.left.equalTo(tempButton!.snp.right)
                        make.width.equalTo(tempButton!.snp.width)
                    }
                    if !showLine {
                        make.right.equalTo(0)
                    }
                })
                tempButton = $0
            }
        }
        
        return QingViewTableNodeMenuBarHeader.init(containerBox: header)
    }
    
    private func createMenuBarItem(title: String, iconName: String, showRightline: Bool) -> UIButton {
        return UIButton.init(type: .custom).then({ (item) in
            let icon: UIImageView = UIImageView.init().then({
                item.addSubview($0)
                $0.image = UIImage.init(named: iconName)
                $0.snp.makeConstraints({ (make) in
                    make.top.equalTo(10)
                    make.centerX.equalTo(item.snp.centerX)
                    make.width.height.equalTo(20)
                })
            })
            
            UILabel.init().do({
                item.addSubview($0)
                $0.text = title
                $0.textColor = UIColor.color9
                $0.font = UIFont.systemFont(ofSize: 11)
                $0.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(item.snp.centerX)
                    make.top.equalTo(icon.snp.bottom).offset(5)
                })
            })
            
            if showRightline {
                UIView.init().do({
                    item.addSubview($0)
                    $0.backgroundColor = UIColor.hexColor(hex: "e9e9e9")
                    $0.snp.makeConstraints({ (make) in
                        make.right.equalTo(0)
                        make.top.equalTo(15)
                        make.bottom.equalTo(-15)
                        make.width.equalTo(1)
                    })
                })
            }
        })
    }
}

class InterestGropusCellNode: ASCellNode, InterestGropusCellNodeLayout {
    
    lazy var segline: ASDisplayNode = {
        return self.makeSegline()
    }()
    
    lazy var content: ASDisplayNode = {
        return self.makeContent()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.segline.backgroundColor = UIColor.hexColor(hex: "f9f9f9")
        self.segline.style.preferredSize = CGSize.init(width: UIScreen.main.bounds.width, height: self.seglineHeight)
        self.content.backgroundColor = UIColor.white
        self.content.style.layoutPosition = CGPoint.init(x: 0, y: self.seglineHeight)
        self.content.style.preferredSize = self.contentSize
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                      spacing: 0,
                                      justifyContent: ASStackLayoutJustifyContent.start,
                                      alignItems: ASStackLayoutAlignItems.stretch,
                                      children: [self.segline, self.content])
    }
}

protocol InterestGropusCellNodeLayout {
    var segline: ASDisplayNode { get }
    var content: ASDisplayNode { get }
}

extension InterestGropusCellNodeLayout where Self: InterestGropusCellNode {
    
    var cellNodeSize: CGSize {
        let height: CGFloat = seglineHeight + sectionTitleHeight + subRightContainerSize.height + contentInset.bottom
        return CGSize.init(width: UIScreen.main.bounds.width,
                           height: height)
    }
    
    var contentSize: CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: self.cellNodeSize.height - seglineHeight)
    }
    
    private var contentInset: UIEdgeInsets {
        return kContentInset
    }
    
    var seglineHeight: CGFloat {
        return 15.0
    }
    
    private var sectionTitleHeight: CGFloat {
        return 40
    }
    
    private var subLeftContainerSize: CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - self.contentInset.left * 3) / 2.0
        let height: CGFloat = width * 0.6
        return CGSize.init(width: width, height: height)
    }
    
    private var subRightContainerSize: CGSize {
        return CGSize.init(width: self.subLeftContainerSize.width,
                           height: self.subLeftContainerSize.height * 2 + self.contentInset.left)
    }
    
    func makeSegline() -> ASDisplayNode {
        return ASDisplayNode.init().then {
            self.addSubnode($0)
            $0.backgroundColor = UIColor.lightGray
        }
    }
    
    func makeContent() -> ASDisplayNode {
        return ASDisplayNode.init().then({ (node) in
            self.addSubnode(node)
            node.frame = CGRect.init(origin: CGPoint.init(x: 0, y: self.seglineHeight),
                                     size: self.contentSize)
        })
    }
    
    func makeContentSubviews() {
        self.makeHotMomLifeBox()
    }
    
    private func makeSectionTitle() {
        ASTextNode.init().do {
            self.content.addSubnode($0)
            $0.frame = CGRect.init(origin: CGPoint.zero,
                                   size: CGSize.init(width: UIScreen.main.bounds.width, height: sectionTitleHeight))
            $0.attributedText = "生活圈"
        }
    }
    
    private func makeHotMomLifeBox() {
        
    }
    
}


