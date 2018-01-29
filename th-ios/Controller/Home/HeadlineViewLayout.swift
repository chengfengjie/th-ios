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
        return self.menuItemSize.height + 30
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
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.lineSpacing = 5.0
        style.alignment = NSTextAlignment.justified
        
        self.classificationTextNode.setText(text: "社会热点", style: self.css.home_index.cateTextStyle)
        self.titleTextNode.setText(text: "悲观，繁荣到极点，过去三年都涨了什么", style: self.css.home_index.titleTextStyle)
        
        let contentText: String = "《侠客行》是唐代大诗人李白借乐府古题创作的一首诗。此诗开头四句从侠客的装束、兵刃、坐骑刻画侠客的形象；第二个四句描写侠客高超的武术和淡泊名利的行藏；第三个四句引入信陵君和侯嬴、朱亥的故事来进一步歌颂侠客，同时也委婉地表达了自己的抱负；最后四句表示，即使侠客的行动没有达到目的，但侠客的骨气依然流芳后世，并不逊色于那些功成名就的英雄。全诗抒发了作者对侠客的倾慕，对拯危济难、用世立功生活的向往，形象地表现了作者的豪情壮志。"
        
        self.contentTextNode.setText(text: contentText, style: self.css.home_index.contentTextStyle)
        
        self.authorIconNode.style.preferredSize = self.css.home_index.authorIconSize
        self.authorIconNode.cornerRadius = self.css.home_index.authorIconSize.width / 2.0
        self.authorIconNode.url = URL.init(string: "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1121475478,2545730346&fm=27&gp=0.jpg")
        
        self.authorTextNode.setText(text: "用时间良久", style: self.css.home_index.authorUnlikeTextStyle)
        
        self.unlikeButtonNode.setTitleText(text: "不喜欢", style: self.css.home_index.authorUnlikeTextStyle)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let authorSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: self.cellNodeElementSpacing,
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
    
    override init() {
        super.init()
        self.imageNode.url = URL.init(string: "http://g.hiphotos.baidu.com/image/h%3D300/sign=bc01b87caf0f4bfb93d09854334e788f/10dfa9ec8a1363275cd315d09a8fa0ec08fac713.jpg")
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
                                                spacing: self.cellNodeElementSpacing,
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
