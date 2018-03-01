//
//  MineViewCollectCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/23.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

class MineCollectCellNode: ASCellNode, MineCollectTopicCellNodeLayout {

    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomline()
    }()

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
    
    var imageNodeArray: [ASImageNode] = []
    
    lazy var deleteButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    init(dataJSON: JSON) {
        super.init()
        self.bottomline.backgroundColor = UIColor.lineColor
        
        self.selectionStyle = .none
        self.shareIconNode.style.preferredSize = CGSize.init(width: 15, height: 15)
        
        self.categoryTextNode.setText(text: "", style: self.categoryStyle)
        self.titleTextNode.setText(text: dataJSON["title"].stringValue, style: self.titleTextStyle)
        self.contentTextNode.setText(text: dataJSON["summary"].stringValue, style: self.contentTextStyle)
        self.shareIconNode.image = UIImage.init(named: "share_blue")
        
        let picUrls: [URL?] = dataJSON["pic"].arrayValue.map { (pic) -> URL? in
            return URL.init(string: pic.stringValue)
        }
        
        self.imageNodeArray = self.makeImageNodes(imageUrlArray: picUrls)
        
        self.deleteButtonNode.setAttributedTitle(" ·  删除"
            .withTextColor(Color.hexColor(hex: "95ccd7")), for: UIControlState.normal)
        self.shareTextNode.attributedText = "分享"
            .withTextColor(Color.hexColor(hex: "95ccd7"))
        
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
                                      justifyContent: ASStackLayoutJustifyContent.start,
                                      alignItems: ASStackLayoutAlignItems.center,
                                      children: [self.shareIconNode, self.shareTextNode, self.deleteButtonNode])
    }
}

protocol MineCollectTopicCellNodeLayout: TopicListCellNodeLayout {
    var deleteButtonNode: ASButtonNode { get }
}
extension MineCollectTopicCellNodeLayout where Self: MineCollectCellNode {
    func makeDeleteButtonNode() -> ASButtonNode {
        return ASButtonNode.init().then({
            self.addSubnode($0)
            $0.setAttributedTitle("删除".attributedString, for: .normal)
        })
    }
}

