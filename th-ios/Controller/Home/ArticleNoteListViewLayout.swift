//
//  ArticleNoteListViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/7/7.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol ArticleNoteListViewLayout {
    
}
extension ArticleNoteListViewLayout {
    
}

class ArticleNoteListHeaderCellNode: ASCellNode, NodeElementMaker {
    
    lazy var textNode: ASTextNode = {
        self.makeAndAddTextNode()
    }()
    
    lazy var imageNode: ASNetworkImageNode = {
        self.makeAndAddNetworkImageNode()
    }()
    
    lazy var textBackground: ASDisplayNode = {
        self.makeAndAddDisplayNode()
    }()
    
    var type: Int = 0
    
    init(dataJSON: JSON) {
        super.init()
        
        self.type = dataJSON["type"].intValue
        
        self.selectionStyle = .none
        
        if self.type == 1 {
            
            self.textBackground.backgroundColor = UIColor.hexColor(hex: "e3f4f8")
            self.textBackground.cornerRadius = 3
            self.textBackground.shadowColor = UIColor.gray.cgColor
            self.textBackground.shadowRadius = 5
            self.textBackground.shadowOpacity = 0.3
            
            self.textNode.attributedText = dataJSON["text"].stringValue
                .withFont(Font.thin(size: 14))
                .withTextColor(Color.color3)
                .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: NSTextAlignment.justified))
            self.textNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: UIScreen.main.bounds.width - 40)
            self.textNode.textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
            
 
            
        } else {
            self.imageNode.defaultImage = UIImage.defaultImage
            let imageWidth: Float = dataJSON["imageWidth"].floatValue
            let imageHeight: Float = dataJSON["imageHeight"].floatValue
            let nodeWidth: Float = Float.init(UIScreen.main.bounds.width) - 40
            let nodeHeight: Float = nodeWidth * (imageHeight / imageWidth)
            self.imageNode.style.preferredSize = CGSize.init(width: nodeWidth.cgFloat, height: nodeHeight.cgFloat)
            if let url = URL.init(string: dataJSON["sourceUrl"].stringValue) {
                self.imageNode.url = url
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.type == 1 {
            let textSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical, spacing: 0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.stretch, children: [self.textNode]);
            let backgroundSpec = ASBackgroundLayoutSpec.init(child: textSpec, background: self.textBackground)
            return ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 10, left: 20, bottom: 20, right: 20), child: backgroundSpec)
        } else {
            return ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 10, left: 20, bottom: 20, right: 20), child: self.imageNode)
        }
    }
    
}

class ArticleNoteListNoteCellNode: ASCellNode, NodeElementMaker {

    var deleteNoteAction: Action<JSON, JSON, HttpError>?
    
    var editNoteAction: Action<JSON, AddEditNoteViewModel, HttpError>?
    
    lazy var noteTextNode: ASTextNode = {
        self.makeAndAddTextNode()
    }()
    
    lazy var backgroundNode: ASDisplayNode = {
        self.makeAndAddDisplayNode()
    }()
    
    lazy var dateNode: ASTextNode = {
        self.makeAndAddTextNode()
    }()
    
    lazy var editNode: ASTextNode = {
        self.makeAndAddTextNode()
    }()
    
    lazy var deleteNode: ASTextNode = {
        self.makeAndAddTextNode()
    }()
    
    let dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.backgroundNode.backgroundColor = UIColor.hexColor(hex: "e6f5d8")
        
        self.noteTextNode.attributedText = dataJSON["content"].stringValue.withFont(Font.sys(size: 14))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 4, alignment: NSTextAlignment.left))
        self.noteTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: UIScreen.main.bounds.width - 80)
        
        self.dateNode.attributedText = dataJSON["lastEditDate"].stringValue.dateFormat()
            .withFont(Font.sys(size: 10)).withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .left));
        
        self.editNode.attributedText = "编辑".withFont(Font.sys(size: 12)).withTextColor(Color.color9).withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: NSTextAlignment.right))
        self.editNode.style.preferredSize = CGSize.init(width: 40, height: 40)
        self.editNode.addTarget(self, action: #selector(self.handleUpdateNote), forControlEvents: ASControlNodeEvent.touchUpInside)

        
        self.deleteNode.attributedText = "删除".withFont(Font.sys(size: 12)).withTextColor(Color.color9).withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: NSTextAlignment.left))
        self.deleteNode.addTarget(self, action: #selector(self.handleDeleteNote), forControlEvents: ASControlNodeEvent.touchUpInside)
        self.deleteNode.style.preferredSize = CGSize.init(width: 40, height: 40)

        
        self.backgroundNode.shadowColor = UIColor.lightGray.cgColor
        self.backgroundNode.shadowRadius = 4
        self.backgroundNode.shadowOpacity = 0.2
        self.backgroundNode.cornerRadius = 5
        
        self.selectionStyle = .none

    }
    
    @objc func handleDeleteNote() {
        self.deleteNoteAction?.apply(self.dataJSON).start()
    }
    
    @objc func handleUpdateNote() {
        self.editNoteAction?.apply(self.dataJSON).start()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let deleteEditSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: 0,
                                                    justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                    alignItems: .center,
                                                    children: [self.deleteNode, self.editNode])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.dateNode, self.noteTextNode, deleteEditSpec])
        let mainInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 20, bottom: 0, right: 20), child: mainSpec)
        
        let backSpec = ASBackgroundLayoutSpec.init(child: mainInset, background: self.backgroundNode)
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20), child: backSpec)
    }
    
}
