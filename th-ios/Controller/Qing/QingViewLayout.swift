//
//  QingViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/22.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

private let kContentInset: UIEdgeInsets = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
private let kSegmentLineSize: CGSize = CGSize.init(width: UIScreen.main.bounds.width, height: 15)

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
    
    lazy var segmentLineNode: ASDisplayNode = {
        return self.makeSegmemtLineNode()
    }()
    
    lazy var sectionTitleTextNode: ASTextNode = {
        return self.makeSectionTitleTextNode()
    }()
    
    lazy var hotMomLifeNode: ASDisplayNode = {
        return self.makeHotMomLifeNode()
    }()
    
    lazy var bredExchangeNode: ASDisplayNode = {
        return self.makeBredExchangeNode()
    }()
    
    lazy var grassTimeNode: ASDisplayNode = {
        return self.makeGrassTimeNode()
    }()

    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.segmentLineNode.backgroundColor = UIColor.hexColor(hex: "f9f9f9")
        
        self.sectionTitleTextNode.attributedText = "兴趣圈".withTextColor(Color.pink)
        
        self.hotMomLifeNode.backgroundColor = UIColor.orange
        
        self.bredExchangeNode.backgroundColor = UIColor.yellow
        
        self.grassTimeNode.backgroundColor = UIColor.green
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let leftSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: self.contentInset.left,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.hotMomLifeNode, self.bredExchangeNode])
        
        let bottomSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                spacing: self.contentInset.left,
                                                justifyContent: ASStackLayoutJustifyContent.start,
                                                alignItems: ASStackLayoutAlignItems.stretch,
                                                children: [leftSpec, self.grassTimeNode])
        
        let inset: UIEdgeInsets = UIEdgeInsets.init(
            top: 0, left: self.contentInset.left,
            bottom: self.contentInset.bottom, right: self.contentInset.right)
        
        let bottomInset = ASInsetLayoutSpec.init(insets: inset, child: bottomSpec)
        
        let sectionTitleInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset,
                                                           child: self.sectionTitleTextNode)
        
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                      spacing: 0,
                                      justifyContent: ASStackLayoutJustifyContent.start,
                                      alignItems: ASStackLayoutAlignItems.stretch,
                                      children: [self.segmentLineNode, sectionTitleInsetSpec, bottomInset])
    }
}

protocol InterestGropusCellNodeLayout {
    var segmentLineNode: ASDisplayNode { get }
    var sectionTitleTextNode: ASTextNode { get }
    var hotMomLifeNode: ASDisplayNode { get }
    var bredExchangeNode: ASDisplayNode { get }
    var grassTimeNode: ASDisplayNode { get }
}

extension InterestGropusCellNodeLayout where Self: InterestGropusCellNode {
    
    var contentInset: UIEdgeInsets {
        return kContentInset
    }
    
    var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var segmentlineSize: CGSize {
        return kSegmentLineSize
    }
    
    var leftItemSize: CGSize {
        let w: CGFloat = (self.width - contentInset.left * 3) / 2.0
        let h: CGFloat = w / 2.0
        return CGSize.init(width: w, height: h)
    }
    
    var rightItemSize: CGSize {
        return CGSize.init(width: self.leftItemSize.width,
                           height: self.leftItemSize.height * 2 + contentInset.left)
    }
    
    func makeSegmemtLineNode() -> ASDisplayNode {
        return ASDisplayNode.init().then({ (node) in
            node.style.preferredSize = self.segmentlineSize
            self.addSubnode(node)
        })
    }
    
    func makeSectionTitleTextNode() -> ASTextNode {
        return ASTextNode.init().then({
            self.addSubnode($0)
        })
    }
    
    func makeHotMomLifeNode() -> ASDisplayNode {
        return ASDisplayNode.init().then({
            self.addSubnode($0)
            $0.backgroundColor = UIColor.orange
            $0.style.preferredSize = self.leftItemSize
        })
    }
    
    func makeBredExchangeNode() -> ASDisplayNode {
        return ASDisplayNode.init().then {
            self.addSubnode($0)
            $0.backgroundColor = UIColor.yellow
            $0.style.preferredSize = self.leftItemSize
        }
    }
    
    func makeGrassTimeNode() -> ASDisplayNode {
        return ASDisplayNode.init().then {
            self.addSubnode($0)
            $0.backgroundColor = UIColor.green
            $0.style.preferredSize = self.rightItemSize
        }
    }
}

class QingHotTodayCellNode: ASCellNode, QingHotTodayCellNodeLayout {
    
    lazy var segmentlineNode: ASDisplayNode = {
        return self.makeSegmentlineNode()
    }()
    
    lazy var sectionTitleTextNode: ASTextNode = {
        return self.makeSectionTitleTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeTitleTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeContentTextNode()
    }()
    
    lazy var sourceAvatarNode: ASImageNode = {
        return self.makeSourceAvatarNode()
    }()
    
    lazy var sourceTextNode: ASTextNode = {
        return self.makeSourceTextNode()
    }()
    
    lazy var viewCountIconNode: ASImageNode = {
        return self.makeViewCountIconNode()
    }()
    
    lazy var viewCountTextNode: ASTextNode = {
        return self.makeViewCountTextNode()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.segmentlineNode.backgroundColor = UIColor.lineColor
        
        self.sectionTitleTextNode.attributedText = "今日热议".withTextColor(UIColor.pink)
        
        self.titleTextNode.attributedText = "只有足够努力,你才能吧毫无道理变成理所当然"
            .withFont(Font.boldSystemFont(ofSize: 16))
            .withTextColor(Color.color3)
        
        self.contentTextNode.attributedText = "只有足够努力,你才能吧毫无道理变成理所当然只有足够努力,你才能吧毫无道理变成理所当然只有足够努力,你才能吧毫无道理变成理所当然"
            .withFont(Font.systemFont(ofSize: 11))
            .withTextColor(Color.color9)
        
        self.sourceAvatarNode.image = UIImage.init(named: "qing_grass_time")
        
        self.sourceTextNode.attributedText = "初恋在线".attributedString
        
        self.viewCountIconNode.image = UIImage.init(named: "qing_eye")
        
        self.viewCountTextNode.attributedText = "123".attributedString
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let lineSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 0,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [self.segmentlineNode])
        
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 15,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [self.sectionTitleTextNode, self.titleTextNode, self.contentTextNode])
        
        let contentInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: contentSpec)
        
        let sourceBox: ASStackLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                                  spacing: 10,
                                                                  justifyContent: ASStackLayoutJustifyContent.start,
                                                                  alignItems: ASStackLayoutAlignItems.center,
                                                                  children: [self.sourceAvatarNode, self.sourceTextNode])
        
        let viewCountBox: ASStackLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                                     spacing: 10,
                                                                     justifyContent: ASStackLayoutJustifyContent.start,
                                                                     alignItems: ASStackLayoutAlignItems.center,
                                                                     children: [self.viewCountIconNode, self.viewCountTextNode])
        
        let bottomBarSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                   spacing: 10,
                                                   justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                   alignItems: ASStackLayoutAlignItems.center,
                                                   children: [sourceBox, viewCountBox])
        
        let bottomBarInsetSpec: ASInsetLayoutSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(
            top: 0, left: self.contentInset.left,bottom: self.contentInset.bottom, right: self.contentInset.right),
                                                        child: bottomBarSpec)
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 0,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [lineSpec, contentInsetSpec, bottomBarInsetSpec])
        
        return mainSpec
    }
    
}

protocol QingHotTodayCellNodeLayout {
    var segmentlineNode: ASDisplayNode { get }
    var sectionTitleTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var sourceAvatarNode: ASImageNode { get }
    var sourceTextNode: ASTextNode { get }
    var viewCountIconNode: ASImageNode { get }
    var viewCountTextNode: ASTextNode { get }
}
extension QingHotTodayCellNodeLayout where Self: QingHotTodayCellNode {
    
    var segmentLineSize: CGSize {
        return kSegmentLineSize
    }
    
    var contentInset: UIEdgeInsets {
        return kContentInset
    }
    
    func makeSegmentlineNode() -> ASDisplayNode {
        return ASDisplayNode.init().then {
            $0.style.preferredSize = self.segmentLineSize
            self.addSubnode($0)
        }
    }
    
    func makeSectionTitleTextNode() -> ASTextNode {
        return ASTextNode.init().then {
            self.addSubnode($0)
        }
    }
    
    func makeTitleTextNode() -> ASTextNode {
        return ASTextNode.init().then {
            self.addSubnode($0)
        }
    }
    
    func makeContentTextNode() -> ASTextNode {
        return ASTextNode.init().then {
            self.addSubnode($0)
        }
    }
    
    func makeSourceAvatarNode() -> ASImageNode {
        return ASImageNode.init().then {
            $0.style.preferredSize = CGSize.init(width: 18, height: 18)
            self.addSubnode($0)
        }
    }
    
    func makeSourceTextNode() -> ASTextNode {
        return ASTextNode.init().then {
            self.addSubnode($0)
        }
    }
    
    func makeViewCountIconNode() -> ASImageNode {
        return ASImageNode.init().then {
            $0.style.preferredSize = CGSize.init(width: 14, height: 14)
            self.addSubnode($0)
        }
    }
    
    func makeViewCountTextNode() -> ASTextNode {
        return ASTextNode.init().then {
            self.addSubnode($0)
        }
    }
    
}



class QingCityCommunityCellNode: ASCellNode, QingCityCommunityCellNodeLayout {
    
    lazy var segmentLineNode: ASDisplayNode = {
        return self.makeSegmentLineNode()
    }()
    
    lazy var sectionTitleTextNode: ASTextNode = {
        return self.makeSectionTitleTextNode()
    }()
    
    private var cityInfoItems: [ASDisplayNode] = []
    
    override init() {
        super.init()
        
        let cityInfos: [String] = ["北京", "广州", "深圳", "佛山", "焦作", "大理"]
        
        self.selectionStyle = .none
        
        self.segmentLineNode.backgroundColor = UIColor.lineColor
        
        self.sectionTitleTextNode.attributedText = "同城圈".withTextColor(Color.pink)
        
        self.cityInfoItems = self.makeCityItems(cityInfoItems: cityInfos)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
        var cityItemSpecs: [ASStackLayoutSpec] = []
        let groupResult: [[ASDisplayNode]] = self.groupArray(groupSize: 2, array: self.cityInfoItems)
        for item in groupResult {
            cityItemSpecs.append(ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                        spacing: self.contentInset.left,
                                                        justifyContent: ASStackLayoutJustifyContent.start,
                                                        alignItems: ASStackLayoutAlignItems.stretch,
                                                        children: item))
        }
        
        let cityItemVartical = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                      spacing: self.contentInset.left,
                                                      justifyContent: ASStackLayoutJustifyContent.start,
                                                      alignItems: ASStackLayoutAlignItems.stretch,
                                                      children: cityItemSpecs)
        
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 15,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [self.sectionTitleTextNode, cityItemVartical])
        
        let contentInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: contentSpec)
        
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                      spacing: 0,
                                      justifyContent: ASStackLayoutJustifyContent.start,
                                      alignItems: ASStackLayoutAlignItems.stretch,
                                      children: [self.segmentLineNode, contentInsetSpec])
    }
    
    func groupArray<T>(groupSize: UInt, array: [T]) -> [[T]] {
        var result: [[T]] = []
        var temp: [T] = []
        
        for item in array {
            if temp.count == groupSize {
                result.append(temp)
                temp = []
            }
            temp.append(item)
        }
        if !temp.isEmpty {
            result.append(temp)
        }
        return result
    }
}

protocol QingCityCommunityCellNodeLayout {
    var segmentLineNode: ASDisplayNode { get }
    var sectionTitleTextNode: ASTextNode { get }
}
extension QingCityCommunityCellNodeLayout where Self: QingCityCommunityCellNode {
    
    var segmentLineSize: CGSize {
        return kSegmentLineSize
    }
    
    var contentInset: UIEdgeInsets {
        return kContentInset
    }
    
    var cityItemSize: CGSize {
        let width: CGFloat = UIScreen.main.bounds.width
        let itemW: CGFloat = (width - self.contentInset.left * 3) / 2.0
        let height: CGFloat = itemW * 0.5
        return CGSize.init(width: itemW, height: height)
    }
    
    func makeSegmentLineNode() -> ASDisplayNode {
        return ASDisplayNode.init().then({
            $0.style.preferredSize = self.segmentLineSize
            self.addSubnode($0)
        })
    }
    
    func makeSectionTitleTextNode() -> ASTextNode {
        return ASTextNode.init().then {
            self.addSubnode($0)
        }
    }
    
    func makeCityItems(cityInfoItems: [String]) -> [ASDisplayNode] {
        var items: [ASDisplayNode] = []
        cityInfoItems.forEach { (cityInfo) in
            items.append(ASDisplayNode.init().then {
                $0.backgroundColor = UIColor.orange
                $0.style.preferredSize = self.cityItemSize
                self.addSubnode($0)
            })
        }
        return items
    }
}

