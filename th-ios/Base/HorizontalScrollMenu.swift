//
//  HorizontalScrollMenu.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HorizontalScrollMenu: BaseView, ASCollectionDataSource, ASCollectionDelegate {
    
    private lazy var collection: ASCollectionNode = {
        return self.makeCollection()
    }()
    
    var dataSource: [String] = ["最新", "热门", "精华", "美食", "职场", "装修", "星座", "故事"]
    
    override func setupSubViews() {
        self.collection.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collection.frame = self.bounds
        if let layout = self.collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize.init(width: 80, height: self.collection.frame.height)
        }
    }
    
    func makeCollectionLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize.init(width: 80, height: 20)
            $0.scrollDirection = .horizontal
        }
    }
    
    func makeCollection() -> ASCollectionNode {
        return ASCollectionNode.init(collectionViewLayout: self.makeCollectionLayout()).then {
            self.addSubnode($0)
            $0.delegate = self
            $0.dataSource = self
            $0.view.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return MenuCellNode(text: self.dataSource[indexPath.row])
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: 40, height: self.frame.height),
                                max: CGSize.init(width: 200, height: self.frame.height))
    }
    
}

fileprivate class MenuCellNode: ASCellNode, NodeElementMaker {
    lazy var textNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    init(text: String) {
        super.init()
        
        self.textNode.setAttributedTitle(text.withTextColor(Color.pink), for: UIControlState.selected)
        self.textNode.setAttributedTitle(text.withTextColor(Color.color6), for: UIControlState.normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec.init(centeringOptions: ASCenterLayoutSpecCenteringOptions.XY,
                                       sizingOptions: ASCenterLayoutSpecSizingOptions.minimumXY,
                                       child: self.textNode)
    }
}
