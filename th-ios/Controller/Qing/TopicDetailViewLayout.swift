//
//  TopicDetailViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/24.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol TopicDetailViewLayout: ReaderLayout {
    
}

class TopicContentCellNode: ReaderContentCellNode {
    
    override init(dataJSON: JSON) {
        super.init(dataJSON: dataJSON)
        
        self.titleTextNode.attributedText = dataJSON["subject"].stringValue
            .withFont(Font.sys(size: 20))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        
        self.authorAvatarImageNode.url = URL.init(string: dataJSON["sAvatar"].stringValue)
        self.authorAvatarImageNode.style.preferredSize = CGSize.init(width: 24, height: 24)
        self.authorAvatarImageNode.cornerRadius = 12
        self.authorAvatarImageNode.defaultImage = UIImage.defaultImage
        
        self.authorTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.sys(size: 13))
            .withTextColor(Color.pink)
        
        self.attendButtonNode.style.preferredSize = CGSize.init(width: 70, height: 26)
        self.attendButtonNode.setAttributedTitle("+ 关注"
            .withFont(Font.sys(size: 13))
            .withTextColor(Color.pink), for: UIControlState.normal)
        self.attendButtonNode.borderColor = UIColor.pink.cgColor
        self.attendButtonNode.borderWidth = 1
        
        self.paragraphContentlist = self.createParagraphContent(datalist: dataJSON["message"].arrayValue)
    }
    
}

class TopicCommentCellNode: CommentCellNode {
    
}
