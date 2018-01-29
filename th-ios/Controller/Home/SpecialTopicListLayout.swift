//
//  SpecialTopicViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class SpecialListCellNode: ASCellNode, SpecialListCellNodeLayout {
    lazy var imageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var descriptionTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.imageNode.url = URL.init(string: "http://g.hiphotos.baidu.com/image/h%3D300/sign=0a9f67bc16950a7b6a3548c43ad0625c/c8ea15ce36d3d539f09733493187e950342ab095.jpg")
        self.titleTextNode.setText(text: "东风没啊实打实大声道", style: self.layoutCss.titleStyle)
        self.descriptionTextNode.setText(text: "JA是全球最大的致力于青少年职业、创业和理财教育的非营利教育机构。 创立于1919年,JA在全球120多个国家开展公益教育课程及活动。中国经济走向全球,需要国际型", style: self.layoutCss.descriptionStyle)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildLayoutSpec()
    }
}

protocol SpecialListCellNodeLayout: NodeElementMaker {
    var imageNode: ASNetworkImageNode { get }
    var titleTextNode: ASTextNode { get }
    var descriptionTextNode: ASTextNode { get }
}
extension SpecialListCellNodeLayout where Self: ASCellNode {
    var layoutCss: SpecialListCellNodeStyle {
        return self.css.home_special_cell_node
    }
    var contentInset: UIEdgeInsets {
        return self.layoutCss.contentInset
    }
    var imageSize: CGSize {
        return self.layoutCss.imageSize
    }
    
    func buildLayoutSpec() -> ASLayoutSpec {
        self.imageNode.style.preferredSize = self.imageSize
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.imageNode, self.titleTextNode, self.descriptionTextNode])
        return ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
    }
}


