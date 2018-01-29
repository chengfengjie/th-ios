//
//  AuthorViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

class SpecialTopicBannerCellNode: ASCellNode, NodeElementMaker {
    lazy var backgroundImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var maskingNode: ASDisplayNode = {
        return ASDisplayNode.init().then {
            self.addSubnode($0)
        }
    }()
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var descriptionTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var imageSize: CGSize = {
        let width = UIScreen.main.bounds.width
        return CGSize.init(width: width, height: width * 0.8)
    }()
    lazy var contentInset: UIEdgeInsets = {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }()
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.backgroundImageNode.url = URL.init(string: "http://g.hiphotos.baidu.com/image/h%3D300/sign=0a9f67bc16950a7b6a3548c43ad0625c/c8ea15ce36d3d539f09733493187e950342ab095.jpg")
        self.backgroundImageNode.style.preferredSize = self.imageSize
        
        self.maskingNode.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        
        self.titleTextNode.setText(text: "东风没啊实打实大声道", style: self.layoutCss.bannerTitleStyle)
        
        self.descriptionTextNode.setText(text: "JA是全球最大的致力于青少年职业、创业和理财教育的非营利教育机构。 创立于1919年,JA在全球120多个国家开展公益教育课程及活动。中国经济走向全球,需要国际型", style: self.layoutCss.bannerDescriptionStyle)
        
        self.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: self.imageSize.height)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 0,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.backgroundImageNode])
        let maskingSpec = ASBackgroundLayoutSpec.init(child: mainSpec, background: self.maskingNode)
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 30,
                                                 justifyContent: ASStackLayoutJustifyContent.end,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [self.titleTextNode, self.descriptionTextNode])
        let contentInset = ASInsetLayoutSpec.init(insets: self.contentInset, child: contentSpec)
        let contentBackSpec = ASBackgroundLayoutSpec.init(child: contentInset, background: maskingSpec)
        return contentBackSpec
    }
    var layoutCss: SpecialTopicStyle {
        return self.css.home_special_topic_info
    }
}

class SpecialTopicArticleListCellNode: NoneContentArticleCellNodeImpl {
    
    override init() {
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
    }
    
}


