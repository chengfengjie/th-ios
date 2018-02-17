//
//  ArticleDetailViewLyout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol ArticleDetailViewLayout: ReaderLayout {
    
}

class ArticleContentCellNode: ReaderContentCellNode {
    
}

class ArticleRelatedCellNode: NoneContentArticleCellNodeImpl {
 
    let dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.showCateTextNode = false
        
        self.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withTextColor(Color.color3)
            .withFont(Font.thin(size: 18))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        self.titleTextNode.maximumNumberOfLines = 2
        self.titleTextNode.truncationMode = .byTruncatingTail
        
        self.sourceIconImageNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        self.sourceIconImageNode.defaultImage = UIImage.defaultImage
        
        self.sourceTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color3)
        
        self.unlikeButtonNode.setAttributedTitle("不喜欢"
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color6), for: UIControlState.normal)
        
        self.imageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        self.imageNode.defaultImage = UIImage.defaultImage
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.dataJSON["pic"].stringValue.isEmpty {
            return self.buildNoneImageLayoutSpec(constrainedSize: constrainedSize)
        } else {
            return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
        }
    }
}

