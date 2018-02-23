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
    let bannerImage: UIImageView
    let signButton: UIButton
    let dayLabel: UILabel
    let dayInfoLabel: UILabel
    init(containerBox: UIView,
         bannerImage: UIImageView,
         signButton: UIButton,
         dayLabel: UILabel,
         dayInfoLabel: UILabel) {
        self.containerBox = containerBox
        self.bannerImage = bannerImage
        self.signButton = signButton
        self.dayLabel = dayLabel
        self.dayInfoLabel = dayInfoLabel
        super.init()
    }
    
    func updateData(dataJSON: JSON) {
        self.bannerImage.yy_setImage(with: URL.init(string: dataJSON["img"].stringValue),
                                     placeholder: UIImage.defaultImage)
        self.dayLabel.text = dataJSON["day"].stringValue
        self.dayInfoLabel.text = "\(dataJSON["dateJq"].stringValue)\n\(dataJSON["dateEn"].stringValue)"
    }
}

class QingViewTableNodeMenuBarHeader: NSObject {
    var containerBox: UIView
    var items: [UIButton] = []
    init(containerBox: UIView) {
        self.containerBox = containerBox
        super.init()
    }
}

protocol QingViewLayout {
    var tableNodeBannerHeader: QingViewTableNodeBannerHeader { get }
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
            $0.contentMode = UIViewContentMode.scaleAspectFill
            $0.layer.masksToBounds = true
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
            $0.colors = [UIColor.white.cgColor, UIColor.init(white: 1, alpha: 0.3).cgColor]
            header.layer.addSublayer($0)
        }
        
        let signButton = UIButton.init(type: UIButtonType.custom).then {
            $0.setTitle("签", for: UIControlState.normal)
            $0.layer.borderColor = UIColor.color6.cgColor
            $0.setTitleColor(UIColor.color6, for: .normal)
            $0.layer.borderWidth = 1
            header.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.right.equalTo(-self.contentInset.right * 2)
                make.top.equalTo(10)
                make.width.height.equalTo(30)
            })
        }
        
        let day = UILabel.init().then {
            header.addSubview($0)
            $0.textColor = UIColor.color3
            $0.font = UIFont.systemFont(ofSize: 50)
            $0.snp.makeConstraints({ (make) in
                make.bottom.equalTo(bannerImage.snp.bottom).offset(-15)
                make.left.equalTo(bannerImage.snp.left).offset(15)
            })
        }
        
        let dayInfo = UILabel().then {
            header.addSubview($0)
            $0.textColor = UIColor.color3
            $0.numberOfLines = 2
            $0.font = UIFont.thin(size: 20)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(day.snp.right).offset(20)
                make.centerY.equalTo(day.snp.centerY)
            })
        }
        
        return QingViewTableNodeBannerHeader.init(containerBox: header,
                                                  bannerImage: bannerImage,
                                                  signButton: signButton,
                                                  dayLabel: day,
                                                  dayInfoLabel: dayInfo)
    }
    
    var menuItemInfo: [(String, String)] {
        return [("最新话题", "qing_the_latest_topic"),
                ("我发表的", "qing_published"),
                ("我参与的", "qing_attended"),
                ("最近浏览", "qing_recently_viewed")]
    }
    
    func makeTopMenuBarHeader() -> QingViewTableNodeMenuBarHeader {
        let header: UIView = UIView.init()
        
        let headerModel = QingViewTableNodeMenuBarHeader.init(containerBox: header)

        
        let itemInfo: [(String, String)] = self.menuItemInfo
        
        var tempButton: UIButton? = nil
        for (index, item) in itemInfo.enumerated() {
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
                $0.tag = index + 100
                headerModel.items.append($0)
            }
        }
        
        return headerModel
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

protocol InterestGropusCellNodeAction: class {
    func handleClickHotMomNode(data: JSON)
    func handleClickBredExchange(data: JSON)
    func handleClickGrassTime(data: JSON)
}

class InterestGropusCellNode: ASCellNode, InterestGropusCellNodeLayout {
    
    weak var action: InterestGropusCellNodeAction?
    
    lazy var segmentLineNode: ASDisplayNode = {
        return self.makeSegmemtLineNode()
    }()
    
    lazy var sectionTitleTextNode: ASTextNode = {
        return self.makeSectionTitleTextNode()
    }()
    
    lazy var hotMomLifeNode: HotMonLifeNode = {
        return self.makeHotMomLifeNode()
    }()
    
    lazy var bredExchangeNode: BredExchangeNode = {
        return self.makeBredExchangeNode()
    }()
    
    lazy var grassTimeNode: GrassTimeNode = {
        return self.makeGrassTimeNode()
    }()

    let dataJSON: [JSON]
    
    required init(action: InterestGropusCellNodeAction, dataJSON: [JSON]) {
        
        self.dataJSON = dataJSON
        
        self.action = action
        
        super.init()
        
        self.selectionStyle = .none
        
        self.segmentLineNode.backgroundColor = UIColor.defaultBGColor
        
        self.sectionTitleTextNode.attributedText = "兴趣圈".withTextColor(Color.pink)
        
        self.hotMomLifeNode.do {
            $0.backgroundColor = UIColor.hexColor(hex: "fef5ef")
            $0.addTarget(self, action: #selector(self.handleClickHotMomNode),
                         forControlEvents: .touchUpInside)
        }
        
        self.bredExchangeNode.do {
            $0.backgroundColor =  UIColor.hexColor(hex: "f4f2fc")
            $0.addTarget(self, action: #selector(self.handleClickBredExchange),
                         forControlEvents: .touchUpInside)
        }
        
        self.grassTimeNode.do {
            $0.backgroundColor = UIColor.hexColor(hex: "ecf4fa")
            $0.addTarget(self, action: #selector(self.handleClickGrassTime),
                         forControlEvents: .touchUpInside)
        }
        
        let elements: [InterestGroupItemLayout] = [self.hotMomLifeNode, self.bredExchangeNode, self.grassTimeNode]
        for (index, item) in elements.enumerated() {
            if index < dataJSON.count {
                item.titleTextNode.attributedText = "# \(dataJSON[index]["name"])"
                    .withFont(Font.sys(size: 18))
            } else {
                (item as! ASDisplayNode).isHidden = true
            }
        }
        
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
    
    @objc func handleClickHotMomNode() {
        self.action?.handleClickHotMomNode(data: self.dataJSON[0])
    }
    
    @objc func handleClickBredExchange() {
        self.action?.handleClickBredExchange(data: self.dataJSON[1])
    }
    
    @objc func handleClickGrassTime() {
        self.action?.handleClickGrassTime(data: self.dataJSON[2])
    }
}

protocol InterestGropusCellNodeLayout {
    var segmentLineNode: ASDisplayNode { get }
    var sectionTitleTextNode: ASTextNode { get }
    var hotMomLifeNode: HotMonLifeNode { get }
    var bredExchangeNode: BredExchangeNode { get }
    var grassTimeNode: GrassTimeNode { get }
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
        let h: CGFloat = UIDevice.current.is_plus_x ? w * 0.5 :  w * 0.7
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
    
    func makeHotMomLifeNode() -> HotMonLifeNode {
        return HotMonLifeNode.init().then({
            self.addSubnode($0)
            $0.style.preferredSize = self.leftItemSize
        })
    }
    
    func makeBredExchangeNode() -> BredExchangeNode {
        return BredExchangeNode.init().then {
            self.addSubnode($0)
            $0.style.preferredSize = self.leftItemSize
        }
    }
    
    func makeGrassTimeNode() -> GrassTimeNode {
        return GrassTimeNode.init().then {
            self.addSubnode($0)
            $0.backgroundColor = UIColor.green
            $0.style.preferredSize = self.rightItemSize
        }
    }
}

/// 辣妈生活板块Node
class HotMonLifeNode: ASControlNode, InterestGroupItemLayout {
    lazy var titleTextNode: ASTextNode = {
        return self.makeTitleTextNode()
    }()
    lazy var descriptionTextNode: ASTextNode = {
        return self.makeDescriptionTextNode()
    }()
    lazy var imageNode: ASImageNode = {
        return self.makeImageNode()
    }()
    override init() {
        super.init()
        
        self.titleTextNode.attributedText = "# 辣妈生活"
            .withFont(Font.systemFont(ofSize: 18))
        
        self.descriptionTextNode.attributedText = "妈妈生活吐槽基地"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3))
        
        self.imageNode.image = UIImage.init(named: "qing_freaky_life")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.smallItemLayoutSpec
    }
}

class BredExchangeNode: ASControlNode, InterestGroupItemLayout {
    lazy var titleTextNode: ASTextNode = {
        return self.makeTitleTextNode()
    }()
    lazy var descriptionTextNode: ASTextNode = {
        return self.makeDescriptionTextNode()
    }()
    lazy var imageNode: ASImageNode = {
        return self.makeImageNode()
    }()
    
    override init() {
        super.init()
        
        self.titleTextNode.attributedText = "# 孕育交流"
            .withFont(Font.systemFont(ofSize: 18))
        
        self.descriptionTextNode.attributedText = "妈妈生活吐槽的空间"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3))
        
        self.imageNode.image = UIImage.init(named: "qing_breeding")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.smallItemLayoutSpec
    }
}

class GrassTimeNode: ASControlNode, InterestGroupItemLayout {
    lazy var titleTextNode: ASTextNode = {
        return self.makeTitleTextNode()
    }()
    lazy var descriptionTextNode: ASTextNode = {
        return self.makeDescriptionTextNode()
    }()
    lazy var imageNode: ASImageNode = {
        return self.makeImageNode()
    }()
    override init() {
        super.init()
        self.titleTextNode.attributedText = "# 种草购物"
            .withFont(Font.systemFont(ofSize: 18))
        
        self.descriptionTextNode.attributedText = "自古以来人们常说眼睛是心灵之窗,拥有一双漂亮的会说话"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3))
        
        self.imageNode.image = UIImage.init(named: "qing_grass_time")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.bigItemLayoutSpec
    }
}

protocol InterestGroupItemLayout {
    var titleTextNode: ASTextNode { get }
    var descriptionTextNode: ASTextNode { get }
    var imageNode: ASImageNode { get }
}
extension InterestGroupItemLayout where Self: ASDisplayNode {
    
    var contentInset: UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15)
    }
    
    var elementSpacing: CGFloat {
        return 15
    }
    
    var imageSize: CGSize {
        return CGSize.init(width: 50, height: 50)
    }
    
    var itemLeftTextNodeWidth: CGFloat {
        let width = self.style.preferredSize.width
            - self.contentInset.left
            - self.contentInset.right
            - self.elementSpacing
            - self.imageSize.width
        return width
    }
    
    func makeTitleTextNode() -> ASTextNode {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }
    func makeDescriptionTextNode() -> ASTextNode {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }
    func makeImageNode() -> ASImageNode {
        return ASImageNode().then {
            self.addSubnode($0)
            $0.style.preferredSize = self.imageSize
        }
    }
    
    var smallItemLayoutSpec: ASLayoutSpec {
        
        self.titleTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: self.itemLeftTextNodeWidth)
        self.descriptionTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: self.itemLeftTextNodeWidth)

        let leftSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 10,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.titleTextNode, self.descriptionTextNode])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [leftSpec, self.imageNode])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
        return mainInsetSpec
    }
    
    var bigItemLayoutSpec: ASLayoutSpec {
        let imageSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                               spacing: 0,
                                               justifyContent: ASStackLayoutJustifyContent.end,
                                               alignItems: ASStackLayoutAlignItems.stretch,
                                               children: [self.imageNode])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: self.elementSpacing,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.titleTextNode, self.descriptionTextNode, imageSpec])
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
        return mainInsetSpec
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
    
    lazy var sourceAvatarNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
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
    
    init(dataJSON: JSON?) {
        super.init()
        
        let data: JSON = dataJSON == nil ? JSON.emptyJSON : dataJSON!
        
        self.selectionStyle = .none
        
        self.segmentlineNode.backgroundColor = UIColor.defaultBGColor
        
        self.sectionTitleTextNode.attributedText = "今日热议".withTextColor(UIColor.pink)
        
        self.titleTextNode.attributedText = data["subject"].stringValue
            .withFont(Font.boldSystemFont(ofSize: 16))
            .withTextColor(Color.color3)
        
        self.contentTextNode.attributedText = data["message"].stringValue
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color9)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 4, alignment: .justified))
        
        self.sourceAvatarNode.url = URL.init(string: data["uimg"].stringValue)
        self.sourceAvatarNode.style.preferredSize = CGSize.init(width: 18, height: 18)
        self.sourceAvatarNode.defaultImage = UIImage.defaultImage
        
        self.sourceTextNode.attributedText = data["author"].stringValue
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color9)
        
        self.viewCountIconNode.image = UIImage.init(named: "qing_eye")
        
        self.viewCountTextNode.attributedText = data["views"].stringValue
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color9)
        
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

protocol QingHotTodayCellNodeLayout: NodeElementMaker {
    var segmentlineNode: ASDisplayNode { get }
    var sectionTitleTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var sourceAvatarNode: ASNetworkImageNode { get }
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
    
    fileprivate var cityInfoItems: [CityCommunityCellNodeItem] = []
    
    init(dataJSON: [JSON]) {
        super.init()
        
        self.selectionStyle = .none
        
        self.segmentLineNode.backgroundColor = UIColor.defaultBGColor
        
        self.sectionTitleTextNode.attributedText = "同城圈".withTextColor(Color.pink)
        
        self.cityInfoItems = self.makeCityItems(cityInfoItems: dataJSON)
        
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
    
    fileprivate func makeCityItems(cityInfoItems: [JSON]) -> [CityCommunityCellNodeItem] {
        var items: [CityCommunityCellNodeItem] = []
        cityInfoItems.forEach { (cityInfo) in
            items.append(CityCommunityCellNodeItem.init(cityInfo: cityInfo).then {
                $0.backgroundColor = UIColor.hexColor(hex: "edf9f5")
                $0.style.preferredSize = self.cityItemSize
                self.addSubnode($0)
            })
        }
        return items
    }
}

fileprivate class CityCommunityCellNodeItem: ASDisplayNode {
    
    lazy var cityNameTextNode: ASTextNode = {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }()
    lazy var cityInfoTextNode: ASTextNode = {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }()
    
    init(cityInfo: JSON) {
        super.init()
        self.cityNameTextNode.attributedText = cityInfo["name"].stringValue
            .withFont(Font.systemFont(ofSize: 16))
            .withTextColor(Color.color3)
        self.cityInfoTextNode.attributedText = "\(cityInfo["favtimes"].stringValue)成员 | \(cityInfo["threads"].stringValue)帖子"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 10,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.cityNameTextNode, self.cityInfoTextNode])
        let position = ASCenterLayoutSpec.init(centeringOptions: ASCenterLayoutSpecCenteringOptions.XY,
                                               sizingOptions: ASCenterLayoutSpecSizingOptions.minimumXY,
                                               child: mainSpec)
        return position
    }
}

