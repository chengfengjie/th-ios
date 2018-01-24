//
//  MineViewCollectCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/23.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

class MineCollectTopicCellNode: ASCellNode, MineCollectTopicCellNodeLayout {
    
    lazy var categoryTextNode: ASTextNode = {
        return self.makeCategoryTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeTitleTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeContentTextNode()
    }()
    
    lazy var shareIconNode: ASImageNode = {
        return self.makeShareIconNode()
    }()
    
    lazy var shareTextNode: ASTextNode = {
        return self.makeShareTextNode()
    }()
    
    var imageNodeArray: [ASImageNode] = []
    
    lazy var deleteButtonNode: ASButtonNode = {
        return self.makeDeleteButtonNode()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.categoryTextNode.attributedText = "种草时间".attributedString
        self.titleTextNode.attributedText = "我的把实打实会话体验".attributedString
        self.contentTextNode.attributedText = "我的把实打实会话体验我的把实打实会话体验我的把实打实会话体验我的把实打实会话体验我的把实打实会话体验".attributedString
        self.shareIconNode.image = UIImage.init(named: "mine_share_gray")
        self.shareTextNode.attributedText = "分享".attributedString
        self.imageNodeArray = self.makeImageNodes(imageUrlArray: [
            URL.init(string: "http://d.hiphotos.baidu.com/image/h%3D300/sign=9af99ce45efbb2fb2b2b5e127f4b2043/a044ad345982b2b713b5ad7d3aadcbef76099b65.jpg"),
            URL.init(string: "http://e.hiphotos.baidu.com/image/h%3D300/sign=8d3a9ea62c7f9e2f6f351b082f31e962/500fd9f9d72a6059099ccd5a2334349b023bbae5.jpg"),
            URL.init(string: "http://img1.imgtn.bdimg.com/it/u=1167088769,847502684&fm=200&gp=0.jpg")])
        
        self.deleteButtonNode.setAttributedTitle(" ·  删除".withTextColor(Color.hexColor(hex: "95ccd7")), for: UIControlState.normal)
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

protocol MineCollectTopicCellNodeLayout: MineViewTopicCellNodeLayout {
    var deleteButtonNode: ASButtonNode { get }
}
extension MineCollectTopicCellNodeLayout where Self: MineCollectTopicCellNode {
    func makeDeleteButtonNode() -> ASButtonNode {
        return ASButtonNode.init().then({
            self.addSubnode($0)
            $0.setAttributedTitle("删除".attributedString, for: .normal)
        })
    }
}

