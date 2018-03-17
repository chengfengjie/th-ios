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
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.imageNode.url = URL.init(string: dataJSON["cover"].stringValue)
        self.imageNode.defaultImage = UIImage.defaultImage
        
        self.titleTextNode.setText(text: dataJSON["title"].stringValue, style: self.layoutCss.titleStyle)
        self.descriptionTextNode.setText(text: dataJSON["summary"].stringValue, style: self.layoutCss.descriptionStyle)
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


