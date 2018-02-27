//
//  MineViewTopicCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/23.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

class MineViewTopicCellNode: ASCellNode, TopicListCellNodeLayout {
    
    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomline()
    }()
    
    var imageNodeArray: [ASImageNode] = []

    lazy var categoryTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var shareIconNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    lazy var shareTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    init(dataJSON: JSON) {
        super.init()
        
        self.bottomline.backgroundColor = UIColor.lineColor
        
        self.selectionStyle = .none
        self.shareIconNode.style.preferredSize = CGSize.init(width: 15, height: 15)
        
        self.categoryTextNode.setText(text: dataJSON["fname"].stringValue, style: self.categoryStyle)
        self.titleTextNode.setText(text: dataJSON["subject"].stringValue, style: self.titleTextStyle)
        self.contentTextNode.setText(text: dataJSON["message"].stringValue, style: self.contentTextStyle)
        self.shareIconNode.image = UIImage.init(named: "share_pink")
        self.shareTextNode.setText(text: "分享", style: self.shareTextStyle)
        
        let picUrls: [URL?] = dataJSON["pic"].arrayValue.map { (pic) -> URL? in
            return URL.init(string: pic.stringValue)
        }
        
        self.imageNodeArray = self.makeImageNodes(imageUrlArray: picUrls)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.imageNodeArray.isEmpty {
            return self.noneImageCellNodeLayoutSpec
        } else if self.imageNodeArray.count == 1 {
            return self.oneImageCellNodeLayoutSpec
        } else if self.imageNodeArray.count >= 3 {
            return self.threeImageCellNodLayoutSpec
        }
        return self.noneImageCellNodeLayoutSpec
    }
    
    func makeCellNodeBottomBarSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                      spacing: 5,
                                      justifyContent: ASStackLayoutJustifyContent.end,
                                      alignItems: ASStackLayoutAlignItems.center,
                                      children: [self.shareIconNode, self.shareTextNode])
    }
}


