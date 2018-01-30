//
//  PublicTableCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class SwitchControlCellNode: ASCellNode, NodeElementMaker {
    
    lazy var switchControlNode: ASDisplayNode = {
        return ASDisplayNode.init(viewBlock: { () -> UIView in
            return UISwitch()
        }).then {
            self.addSubnode($0)
        }
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    private var bottomline: Bool = false
    
    private lazy var bottomlineNode: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    
    init(title: String, bottomline: Bool) {
        self.bottomline = bottomline
        super.init()
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.white
        
        self.bottomlineNode.backgroundColor = bottomline ? UIColor.lineColor : UIColor.clear
        self.bottomlineNode.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: 1)
        
        self.titleTextNode.attributedText = title
            .withFont(Font.systemFont(ofSize: 14))
            .withTextColor(Color.color3)
        
        self.switchControlNode.style.preferredSize = CGSize.init(width: 51, height: 31)
        self.switchControlNode.backgroundColor = UIColor.white
        
        DispatchQueue.main.async {
            if let switchControl = self.switchControlNode.view as? UISwitch {
                switchControl.tintColor = UIColor.pink
                switchControl.onTintColor = UIColor.pink
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 0,
                                              justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.titleTextNode, self.switchControlNode])
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(0, 20, 0, 20), child: mainSpec)
        
        let lineSpec = ASRelativeLayoutSpec.init(horizontalPosition: ASRelativeLayoutSpecPosition.start,
                                                 verticalPosition: ASRelativeLayoutSpecPosition.end,
                                                 sizingOption: ASRelativeLayoutSpecSizingOption.minimumHeight,
                                                 child: self.bottomlineNode)
        
        return ASWrapperLayoutSpec.init(layoutElements: [mainInsetSpec, lineSpec])
    }
}

class IndicatorCellNode: ASCellNode, NodeElementMaker {
    
    lazy var textNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    private lazy var bottomlineNode: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    
    private lazy var indicatorImageNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    init(title: String, bottomline: Bool = true) {
        super.init()
        
        self.backgroundColor = UIColor.white
        
        self.indicatorImageNode.image = UIImage.init(named: "qing_right")
        self.indicatorImageNode.style.preferredSize = CGSize.init(width: 16, height: 16)
        self.indicatorImageNode.alpha = 0.7
        
        self.bottomlineNode.backgroundColor = bottomline ? UIColor.lineColor : UIColor.clear
        self.bottomlineNode.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: 1)

        self.textNode.attributedText = title
            .withFont(Font.systemFont(ofSize: 14))
            .withTextColor(Color.color3)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let lineSpec = ASRelativeLayoutSpec.init(horizontalPosition: ASRelativeLayoutSpecPosition.start,
                                                 verticalPosition: ASRelativeLayoutSpecPosition.end,
                                                 sizingOption: ASRelativeLayoutSpecSizingOption.minimumHeight,
                                                 child: self.bottomlineNode)
        
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                 spacing: 0,
                                                 justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                 alignItems: ASStackLayoutAlignItems.center,
                                                 children: [self.textNode, self.indicatorImageNode])

        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(0, 20, 0, 20), child: contentSpec)
        
        let mainSpec = ASCenterLayoutSpec.init(centeringOptions: ASCenterLayoutSpecCenteringOptions.Y,
                                               sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: mainInsetSpec)
        
        
        return ASWrapperLayoutSpec.init(layoutElements: [mainSpec, lineSpec])
    }
    
}

class SubtitleCellNode: ASCellNode, NodeElementMaker {
    
    lazy var textNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var subTitleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    private lazy var bottomlineNode: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    
    init(title: String, subTitle: String, bottomline: Bool = true) {
        super.init()
        
        self.backgroundColor = UIColor.white
        
        self.bottomlineNode.backgroundColor = bottomline ? UIColor.lineColor : UIColor.clear
        self.bottomlineNode.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: 1)
        
        self.textNode.attributedText = title
            .withFont(Font.systemFont(ofSize: 14))
            .withTextColor(Color.color3)
        
        self.subTitleTextNode.attributedText = subTitle
            .withFont(Font.systemFont(ofSize: 10))
            .withTextColor(Color.color3)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let lineSpec = ASRelativeLayoutSpec.init(horizontalPosition: ASRelativeLayoutSpecPosition.start,
                                                 verticalPosition: ASRelativeLayoutSpecPosition.end,
                                                 sizingOption: ASRelativeLayoutSpecSizingOption.minimumHeight,
                                                 child: self.bottomlineNode)
        
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                 spacing: 0,
                                                 justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                 alignItems: ASStackLayoutAlignItems.center,
                                                 children: [self.textNode, self.subTitleTextNode])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(0, 20, 0, 20), child: contentSpec)
        
        let mainSpec = ASCenterLayoutSpec.init(centeringOptions: ASCenterLayoutSpecCenteringOptions.Y,
                                               sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: mainInsetSpec)
        
        
        return ASWrapperLayoutSpec.init(layoutElements: [mainSpec, lineSpec])
    }
}


