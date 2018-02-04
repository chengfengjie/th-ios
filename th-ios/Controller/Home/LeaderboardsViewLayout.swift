//
//  LeaderboardsViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

fileprivate let kContentInset: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)

protocol LeaderboardsViewLayout {
    var headerChangeControl: HeaderChangeControl { get }
}
extension LeaderboardsViewLayout where Self: LeaderboardsViewController {
    var headerChangeControlSize: CGSize {
        return CGSize.init(width: self.window_width, height: 45)
    }
    func makeHeaderChangeControl() -> HeaderChangeControl {
        return HeaderChangeControl().then {
            $0.titles = ["24H热门", "七日热门", "三十日热门"]
            $0.frame = CGRect.init(origin: CGPoint.zero, size: self.headerChangeControlSize)
        }
    }
}


class LeaderboardsViewCellNode: NoneContentArticleCellNodeImpl {

    let dataJSON: JSON
    
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.categoryTextNode.attributedText = dataJSON["catname"].stringValue
            .withFont(Font.songTi(size: 12))
            .withTextColor(Color.color9)
        
        self.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withTextColor(Color.color3)
            .withFont(Font.sys(size: 18))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        self.titleTextNode.maximumNumberOfLines = 2
        self.titleTextNode.truncationMode = .byTruncatingTail
        
        
        self.imageNode.defaultImage = UIImage.defaultImage
        self.imageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        
        self.sourceIconImageNode.defaultImage = UIImage.defaultImage
        self.sourceIconImageNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        
        self.sourceTextNode.attributedText = dataJSON["author"].stringValue
            .withTextColor(Color.color9)
            .withFont(Font.sys(size: 12))
        
        self.unlikeButtonNode.setAttributedTitle("不喜欢"
            .withTextColor(Color.color9)
            .withFont(Font.sys(size: 12)), for: UIControlState.normal)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.dataJSON["pic"].stringValue.isEmpty {
            return self.buildNoneImageLayoutSpec(constrainedSize: constrainedSize)
        } else {
            return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
        }
    }
    
}




