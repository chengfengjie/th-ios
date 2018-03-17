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
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.backgroundImageNode.url = URL.init(string: dataJSON["cover"].stringValue)
        self.backgroundImageNode.style.preferredSize = self.imageSize
        
        self.maskingNode.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        
        self.titleTextNode.setText(text: dataJSON["title"].stringValue, style: self.layoutCss.bannerTitleStyle)
        
        self.descriptionTextNode.setText(text: dataJSON["summary"].stringValue,
                                         style: self.layoutCss.bannerDescriptionStyle)
        
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
    
    init(dataJSON: JSON) {
        super.init()
        
        self.categoryTextNode.setText(text: dataJSON["catename"].stringValue, style: self.layoutCss.cateNameTextStyle)
        self.titleTextNode.setText(text: dataJSON["title"].stringValue, style: self.layoutCss.titleTextStyle)
        self.imageNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        self.imageNode.style.preferredSize = self.layoutCss.imageSize
        
        self.sourceIconImageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        self.sourceIconImageNode.style.preferredSize = self.layoutCss.sourceIconSize
        
        self.sourceTextNode.setText(text: dataJSON["author"].stringValue, style: self.layoutCss.sourceNameTextStyle)
        
        self.unlikeButtonNode.setTitleText(text: "", style: self.layoutCss.sourceNameTextStyle)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
    }
    
}


