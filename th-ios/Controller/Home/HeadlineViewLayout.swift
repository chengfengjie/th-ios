//
//  HeadlineViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/20.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import JYCarousel

class HeadlineTableNodeHeader: CarouseTableNodeHeader {
    var leaderboardsButton: UIButton? = nil
    var authorButton: UIButton? = nil
    var specialTopicButton: UIButton? = nil
    var treeHoleButton: UIButton? = nil
    init(carouseTableNodeHeader: CarouseTableNodeHeader) {
        super.init(container: carouseTableNodeHeader.container, carouse: carouseTableNodeHeader.carouse)
    }
}

protocol HeadlineViewControllerLayout: CarouselTableHeaderProtocol {}

extension HeadlineViewControllerLayout where Self: HeadlineViewController {

    var menuItemSize: CGSize {
        return CGSize.init(width: 40, height: 40)
    }
    var menuBarHeight: CGFloat {
        return 70
    }
    var tableNodeHeaderBounds: CGRect {
        let height: CGFloat = self.carouseBounds.height + self.menuBarHeight
        return CGRect.init(x: 0, y: 0, width: self.window_width, height: height)
    }
    func makeHeadlineTableNodeHeader() -> HeadlineTableNodeHeader {
        
        let carouseHeader: CarouseTableNodeHeader = self.makeCarouseHeaderBox()
        carouseHeader.container.frame = self.tableNodeHeaderBounds
        
        let container: UIView = carouseHeader.container
        
        let menuBar: UIView = UIView().then { (bar) in
            container.addSubview(bar)
            bar.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(self.menuBarHeight)
            })
        }
        
        let itemWidth: CGFloat = self.menuItemSize.width
        let leftInset: CGFloat = 25
        let interval: CGFloat = (self.window_width - leftInset * 2.0 - itemWidth * 4.0) / 3.0
        
        let leaderboardsButton: UIButton = createMenuButton(title: "排行", color: UIColor.hexColor(hex: "a6dde8"))
        leaderboardsButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(leftInset)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(menuBar.snp.centerY)
            })
        }

        let authorButton: UIButton = createMenuButton(title: "作者", color: UIColor.hexColor(hex: "bca5f1"))
        authorButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(leaderboardsButton.snp.right).offset(interval)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(leaderboardsButton.snp.centerY)
            })
        }
        
        let specialButton: UIButton = createMenuButton(title: "专题", color: UIColor.hexColor(hex: "f7d661"))
        specialButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(authorButton.snp.right).offset(interval)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(leaderboardsButton.snp.centerY)
            })
        }

        let treeHoleButton: UIButton = createMenuButton(title: "树洞", color: UIColor.hexColor(hex: "b2e183"))
        treeHoleButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(specialButton.snp.right).offset(interval)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(leaderboardsButton.snp.centerY)
            })
        }
        
        return HeadlineTableNodeHeader.init(carouseTableNodeHeader: carouseHeader).then({
            $0.leaderboardsButton = leaderboardsButton
            $0.authorButton = authorButton
            $0.specialTopicButton = specialButton
            $0.treeHoleButton = treeHoleButton
        })
    }
    
    private func createMenuButton(title: String, color: UIColor) -> UIButton {
        return UIButton.init(type: UIButtonType.custom).then({ (item) in
            item.setTitle(title, for: UIControlState.normal)
            item.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            item.layer.cornerRadius = self.menuItemSize.width / 2.0
            item.layer.backgroundColor = color.cgColor
        })
    }
}


class ArticleListCellNode: ASCellNode, ArticleListCellNodeLayout {
    
    lazy var classificationTextNode: ASTextNode = {
        return self.makeClassificationTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeTitleTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeContentTextNode()
    }()
    
    lazy var authorIconNode: ASImageNode = {
        return self.makeAuthorIconNode()
    }()
    
    lazy var authorTextNode: ASTextNode = {
        return self.makeAuthorTextNode()
    }()
    
    lazy var unlikeButtonNode: ASButtonNode = {
        return self.makeUnlikeBtnNode()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.lineSpacing = 5.0
        style.alignment = NSTextAlignment.justified
        
        self.classificationTextNode.attributedText = "社会热点".attributedString
        self.titleTextNode.attributedText = "悲观，繁荣到极点，过去三年都涨了什么".withFont(UIFont.systemFont(ofSize: 24))
        self.contentTextNode.attributedText = "《侠客行》是唐代大诗人李白借乐府古题创作的一首诗。此诗开头四句从侠客的装束、兵刃、坐骑刻画侠客的形象；第二个四句描写侠客高超的武术和淡泊名利的行藏；第三个四句引入信陵君和侯嬴、朱亥的故事来进一步歌颂侠客，同时也委婉地表达了自己的抱负；最后四句表示，即使侠客的行动没有达到目的，但侠客的骨气依然流芳后世，并不逊色于那些功成名就的英雄。全诗抒发了作者对侠客的倾慕，对拯危济难、用世立功生活的向往，形象地表现了作者的豪情壮志。".withParagraphStyle(style)
        self.authorIconNode.image = nil
        self.authorTextNode.attributedText = "用时间良久".attributedString
        
        self.authorIconNode.style.preferredSize = CGSize.init(width: 30, height: 30)
        self.authorIconNode.backgroundColor = UIColor.orange
        
        self.unlikeButtonNode.setAttributedTitle("不喜欢".attributedString, for: UIControlState.normal)
        
        self.unlikeButtonNode.backgroundColor = UIColor.orange
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let authorSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: self.cellNodeElementPatch,
                                             justifyContent: ASStackLayoutJustifyContent.start,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [self.authorIconNode, self.authorTextNode])
        
        let barSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: self.cellNodeElementPatch,
                                             justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [authorSpec, self.unlikeButtonNode])
        
        
        let spec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                          spacing: self.cellNodeElementPatch,
                                          justifyContent: .start,
                                          alignItems: .stretch,
                                          children: [self.classificationTextNode,
                                                     self.titleTextNode,
                                                     self.contentTextNode,
                                                     barSpec])
        
        let insetSpec = ASInsetLayoutSpec.init(insets: self.cellNodeContentInset, child: spec)
        
        return ASWrapperLayoutSpec.init(layoutElements: [insetSpec])
        
    }
}

class ArticleListImageCellNode: ArticleListCellNode, ArticleListImageCellNodeLayout {
    lazy var imageNode: ASImageNode = {
        return self.makeImageNode()
    }()
    
    override init() {
        super.init()
        self.imageNode.backgroundColor = UIColor.orange
        self.imageNode.style.preferredSize = self.articleImageSize
        self.titleTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: self.titleNodeMaxWidth)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let titleImageSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: self.cellNodeElementPatch,
                                                    justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                    alignItems: ASStackLayoutAlignItems.start,
                                                    children: [self.titleTextNode, self.imageNode])
        
        let authorSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                spacing: self.cellNodeElementPatch,
                                                justifyContent: ASStackLayoutJustifyContent.start,
                                                alignItems: ASStackLayoutAlignItems.center,
                                                children: [self.authorIconNode, self.authorTextNode])
        
        let barSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: self.cellNodeElementPatch,
                                             justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [authorSpec, self.unlikeButtonNode])
        
        
        let spec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                          spacing: self.cellNodeElementPatch,
                                          justifyContent: .start,
                                          alignItems: .stretch,
                                          children: [self.classificationTextNode,
                                                     titleImageSpec,
                                                     self.contentTextNode,
                                                     barSpec])
        
        let insetSpec = ASInsetLayoutSpec.init(insets: self.cellNodeContentInset,child: spec)
        
        return ASWrapperLayoutSpec.init(layoutElements: [insetSpec])
        
    }
}

protocol ArticleListCellNodeLayout {
    var classificationTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var authorIconNode: ASImageNode { get }
    var authorTextNode: ASTextNode { get }
    var unlikeButtonNode: ASButtonNode { get }
}

protocol ArticleListImageCellNodeLayout: ArticleListCellNodeLayout {
    var imageNode: ASImageNode { get }
}

extension ArticleListCellNodeLayout where Self: ASCellNode {
    
    var cellNodeContentInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    var cellNodeElementPatch: CGFloat {
        return 20
    }
    
    var layoutSpec: ASLayoutSpec {
        return ASLayoutSpec.init()
    }
    
    func makeClassificationTextNode() -> ASTextNode {
        return ASTextNode.init().then({ (l) in
            l.attributedText = "社会热点".attributedString
            self.addSubnode(l)
        })
    }
    
    func makeTitleTextNode() -> ASTextNode {
        return ASTextNode.init().then({ (node) in
            self.addSubnode(node)
        })
    }
    
    func makeContentTextNode() -> ASTextNode {
        return ASTextNode.init().then({ (l) in
            self.addSubnode(l)
        })
    }
    
    func makeAuthorIconNode() -> ASImageNode {
        return ASImageNode.init().then({ (i) in
            self.addSubnode(i)
        })
    }
    
    func makeAuthorTextNode() -> ASTextNode {
        return ASTextNode.init().then({ (l) in
            self.addSubnode(l)
        })
    }
    
    func makeUnlikeBtnNode() -> ASButtonNode {
        return ASButtonNode.init().then({ (b) in
            self.addSubnode(b)
        })
    }
}

extension ArticleListImageCellNodeLayout where Self: ASCellNode {
    var articleImageSize: CGSize {
        return CGSize.init(width: 70, height: 50)
    }
    var titleNodeMaxWidth: CGFloat {
        let viewWidth: CGFloat = UIScreen.main.bounds.width
        let nodePatch: CGFloat = self.cellNodeElementPatch
        let leftInset: CGFloat = self.cellNodeContentInset.left
        let rightInset: CGFloat = self.cellNodeContentInset.right
        return viewWidth - nodePatch - self.articleImageSize.width - leftInset - rightInset
    }
    func makeImageNode() -> ASImageNode {
        return ASImageNode.init().then({ (node) in
            self.addSubnode(node)
        })
    }
}
