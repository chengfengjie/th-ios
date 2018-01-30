//
//  HorizontalScrollMenu.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HorizontalScrollMenu: BaseView, ASCollectionDataSource, ASCollectionDelegate {
    
    var currentIndexPath: IndexPath = IndexPath.init(row: 0, section: 0)
    
    private lazy var collection: ASCollectionNode = {
        return self.makeCollection()
    }()
    
    private let line = UIView()
    
    var dataSource: [String] = ["最新", "热门", "精华", "美食", "职场", "装修", "星座", "故事"]
    
    override func setupSubViews() {
        self.collection.backgroundColor = UIColor.white
        
        UIView().do {
            self.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(0)
                make.height.equalTo(1.0 / UIScreen.main.scale)
            })
            $0.backgroundColor = UIColor.lineColor
        }
        
        self.collection.view.addSubview(line)
        line.backgroundColor = UIColor.pink
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collection.frame = self.bounds
        if let layout = self.collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize.init(width: 80, height: self.collection.frame.height)
        }
        line.frame = CGRect.init(origin: CGPoint.init(x: 0, y: self.frame.height-2),
                                 size: CGSize.init(width: 40, height: 2))
    }
    
    func makeCollectionLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize.init(width: 80, height: 20)
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 20
            $0.minimumInteritemSpacing = 20
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
            return MenuCellNode(text: self.dataSource[indexPath.row]).then {
               $0.textNode.isSelected = indexPath.row == self.currentIndexPath.row
            }
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: 40, height: self.frame.height),
                                max: CGSize.init(width: 40, height: self.frame.height))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        if let cellNode = collectionNode.nodeForItem(at: currentIndexPath) as? MenuCellNode {
            cellNode.textNode.isSelected = false
        }
        if let cellNode = collectionNode.nodeForItem(at: indexPath) as? MenuCellNode {
            cellNode.textNode.isSelected = true
            print(cellNode.position)
        }
        self.currentIndexPath = indexPath
        
        UIView.animate(withDuration: 0.2) {
            self.line.frame = CGRect.init(origin: CGPoint.init(x: CGFloat(indexPath.row * 60), y: self.frame.height-2),
                                     size: CGSize.init(width: 40, height: 2))
        }

    }
}

fileprivate class MenuCellNode: ASCellNode, NodeElementMaker {
    lazy var textNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    init(text: String) {
        super.init()
        
        self.textNode.setAttributedTitle(text.withTextColor(Color.pink).withFont(Font.systemFont(ofSize: 16)),
                                         for: UIControlState.selected)
        self.textNode.setAttributedTitle(text.withTextColor(Color.color6).withFont(Font.systemFont(ofSize: 13)),
                                         for: UIControlState.normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec.init(centeringOptions: ASCenterLayoutSpecCenteringOptions.XY,
                                       sizingOptions: ASCenterLayoutSpecSizingOptions.minimumXY,
                                       child: self.textNode)
    }
}
