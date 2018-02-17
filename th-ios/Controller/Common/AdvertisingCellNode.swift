//
//  AdvertisingCellNode.swift
//  th-ios
//
//  Created by chengfj on 2018/2/9.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class AdvertisingCellNode: ASCellNode, NodeElementMaker {
    
    lazy var adImageCellNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    var bannerContentInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    var bannerSize: CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - self.bannerContentInset.left - self.bannerContentInset.right
        let height: CGFloat = width * 0.35
        return CGSize.init(width: width, height: height)
    }
    
    init(dataJSON: JSON) {
        super.init()
        
        self.adImageCellNode.style.preferredSize = self.bannerSize
        
        self.adImageCellNode.url = URL.init(string: dataJSON["url"].stringValue)
        
        self.adImageCellNode.defaultImage = UIImage.defaultImage
        
        print(dataJSON["url"].stringValue)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec.init(insets: self.bannerContentInset, child: self.adImageCellNode)
    }
    
}
