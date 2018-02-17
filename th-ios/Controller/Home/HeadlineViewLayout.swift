//
//  HeadlineViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/20.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import JYCarousel

class HeadlineTopMenuBarHeader: NSObject {
    var container: UIView
    var leaderboardsButton: UIButton
    var authorButton: UIButton
    var specialTopicButton: UIButton
    var treeHoleButton: UIButton
    init(container: UIView, item1: UIButton, item2: UIButton, item3: UIButton, item4: UIButton) {
        self.container = container
        self.leaderboardsButton = item1
        self.authorButton = item2
        self.specialTopicButton = item3
        self.treeHoleButton = item4
        super.init()
    }
}

enum HeadelineTableNodeHeaderItemType {
    case leaderboards
    case author
    case special
    case treehole
}

protocol HeadlineViewControllerLayout: CarouselTableHeaderProtocol {
    func handleClickTableNodeHeaderItem(type: HeadelineTableNodeHeaderItemType)
}

extension HeadlineViewControllerLayout where Self: HeadlineViewController {

    var menuItemSize: CGSize {
        return self.css.home_index.headerItemSize
    }
    var menuBarHeight: CGFloat {
        return self.menuItemSize.height + 50
    }
    
    func makeMenuBarHeader() -> HeadlineTopMenuBarHeader {
        let menuBar: UIView = UIView()
                
        UIView.init().do {
            menuBar.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(0)
                make.height.equalTo(1.0 / UIScreen.main.scale)
            })
            $0.backgroundColor = UIColor.lineColor
        }
        
        let itemWidth: CGFloat = self.menuItemSize.width
        let leftInset: CGFloat = 20
        let interval: CGFloat = (self.window_width - leftInset * 2.0 - itemWidth * 4.0) / 3.0
        
        let leaderboardsButton: UIButton = createMenuButton(title: "排行", color: UIColor.hexColor(hex: "a6dde8"))
        leaderboardsButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(leftInset)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(menuBar.snp.centerY)
            })
            item.reactive.controlEvents(.touchUpInside).observe({ [weak self] (_) in
                self?.handleClickTableNodeHeaderItem(type: HeadelineTableNodeHeaderItemType.leaderboards)
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
            item.reactive.controlEvents(.touchUpInside).observe({ [weak self] (_) in
                self?.handleClickTableNodeHeaderItem(type: HeadelineTableNodeHeaderItemType.author)
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
            item.reactive.controlEvents(.touchUpInside).observe({ [weak self] (_) in
                self?.handleClickTableNodeHeaderItem(type: HeadelineTableNodeHeaderItemType.special)
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
            item.reactive.controlEvents(.touchUpInside).observe({ [weak self] (_) in
                self?.handleClickTableNodeHeaderItem(type: HeadelineTableNodeHeaderItemType.treehole)
            })
        }
        
        return HeadlineTopMenuBarHeader.init(container: menuBar,
                                            item1: leaderboardsButton,
                                            item2: authorButton,
                                            item3: specialButton,
                                            item4: treeHoleButton)
        
    }
    
    func makeHeadlineTableNodeHeader() -> CarouseTableNodeHeader {
        let carouseHeader: CarouseTableNodeHeader = self.makeCarouseHeaderBox()
        carouseHeader.container.frame = self.carouseBounds
        print(carouseHeader.container.frame)
        return carouseHeader
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
        return self.makeAndAddTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var authorIconNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var authorTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var unlikeButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.classificationTextNode.attributedText = dataJSON["catname"].stringValue
            .withFont(Font.songTi(size: 12))
            .withTextColor(Color.color9)
        
        self.titleTextNode.maximumNumberOfLines = 2
        self.titleTextNode.truncationMode = .byTruncatingTail
        self.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withFont(Font.thin(size: 18))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        
        self.contentTextNode.attributedText = dataJSON["summary"].stringValue
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color9)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
        
        self.authorIconNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        self.authorIconNode.defaultImage = UIImage.defaultImage
        self.authorIconNode.style.preferredSize = CGSize.init(width: 18, height: 18)
        
        self.authorTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color9)
        
        self.unlikeButtonNode.setAttributedTitle("不喜欢"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color9), for: UIControlState.normal)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let authorSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: 5,
                                             justifyContent: ASStackLayoutJustifyContent.start,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [self.authorIconNode, self.authorTextNode])
        
        let barSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: self.cellNodeElementSpacing,
                                             justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [authorSpec, self.unlikeButtonNode])
        
        
        let spec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                          spacing: self.cellNodeElementSpacing,
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
    lazy var imageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    override init(dataJSON: JSON) {
        super.init(dataJSON: dataJSON)
        self.imageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        self.imageNode.defaultImage = UIImage.defaultImage
        self.imageNode.style.preferredSize = self.articleImageSize
        self.titleTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: self.titleNodeMaxWidth)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let titleImageSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: self.cellNodeElementSpacing,
                                                    justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                    alignItems: ASStackLayoutAlignItems.start,
                                                    children: [self.titleTextNode, self.imageNode])
        
        let authorSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                spacing: 5,
                                                justifyContent: ASStackLayoutJustifyContent.start,
                                                alignItems: ASStackLayoutAlignItems.center,
                                                children: [self.authorIconNode, self.authorTextNode])
        
        let barSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: self.cellNodeElementSpacing,
                                             justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [authorSpec, self.unlikeButtonNode])
        
        
        let spec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                          spacing: self.cellNodeElementSpacing,
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

protocol ArticleListCellNodeLayout: NodeElementMaker {
    var classificationTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var authorIconNode: ASNetworkImageNode { get }
    var authorTextNode: ASTextNode { get }
    var unlikeButtonNode: ASButtonNode { get }
}

protocol ArticleListImageCellNodeLayout: ArticleListCellNodeLayout {
    var imageNode: ASNetworkImageNode { get }
}

extension ArticleListCellNodeLayout where Self: ASCellNode {
    
    var cellNodeContentInset: UIEdgeInsets {
        return self.css.home_index.contentInset
    }
    
    var cellNodeElementSpacing: CGFloat {
        return self.css.home_index.elementSpacing.cgFloat
    }
}

extension ArticleListImageCellNodeLayout where Self: ASCellNode {
    var articleImageSize: CGSize {
        return self.css.home_index.imageSize
    }
    var titleNodeMaxWidth: CGFloat {
        let viewWidth: CGFloat = UIScreen.main.bounds.width
        let nodePatch: CGFloat = self.cellNodeElementSpacing
        let leftInset: CGFloat = self.cellNodeContentInset.left
        let rightInset: CGFloat = self.cellNodeContentInset.right
        return viewWidth - nodePatch - self.articleImageSize.width - leftInset - rightInset
    }
}
