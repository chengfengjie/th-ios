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
    
    private var isFollow: Bool = false
    
    var followAction: Action<(), JSON, RequestError>?
    
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
        
        self.isFollow = dataJSON["isfollow"].stringValue == "1"
        
        if dataJSON["isfollow"].stringValue == "1" {
            self.attendButtonNode.setAttributedTitle("取消关注"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.color9), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.color9.cgColor
            self.attendButtonNode.borderWidth = 1
        } else {
            self.attendButtonNode.setAttributedTitle("+ 关注"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.pink), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.pink.cgColor
            self.attendButtonNode.borderWidth = 1
        }
        
        self.paragraphContentlist = self.createParagraphContent(datalist: dataJSON["message"].arrayValue)
        
        self.sourceContainer.textNode.attributedText = "来自: "
            .withTextColor(Color.color3)
            .withFont(Font.sys(size: 16)) + dataJSON["author"].stringValue
                .withFont(Font.sys(size: 16))
                .withTextColor(Color.pink)
        
        self.attendButtonNode.addTarget(
            self, action: #selector(self.handleFollowUser),
            forControlEvents: .touchUpInside)
        
    }
    
    @objc func handleFollowUser() {
        
        self.isFollow = !self.isFollow
        
        self.updateFollowState()
        
        self.followAction?.apply(()).start()
        
    }
    
    func updateFollowState() {
        if self.isFollow {
            self.attendButtonNode.setAttributedTitle("取消关注"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.color9), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.color9.cgColor
            self.attendButtonNode.borderWidth = 1
        } else {
            self.attendButtonNode.setAttributedTitle("+ 关注"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.pink), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.pink.cgColor
            self.attendButtonNode.borderWidth = 1
        }

    }
    
}

class TopicCommentCellNode: CommentCellNode {
    
    let dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.avatar.defaultImage = UIImage.defaultImage
        self.avatar.url = URL.init(string: dataJSON["head"].stringValue)
        
        self.nameTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.sys(size: 14))
            .withTextColor(Color.pink)
        
        self.dateTimeTextNode.attributedText = dataJSON["dateline"].stringValue
            .dateFormat(type: DateFormatType.normal)
            .withTextColor(Color.color9)
            .withFont(Font.sys(size: 12))
        
        self.goodButtonNode.image = nil
        self.goodButtonNode.style.preferredSize = CGSize.init(width: 14, height: 14)
        
        self.goodTotalTextNode.attributedText = ""
            .withFont(.sys(size: 12))
            .withTextColor(Color.color9)
        
        self.commentTextNode.attributedText = dataJSON["message"]["msg"].stringValue
            .withTextColor(Color.color3).withFont(Font.sys(size: 16))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: NSTextAlignment.justified))
        self.commentTextNode.style.width = ASDimension.init(unit: .points, value: self.rightContentMaxWidth)
        
        self.reportButtonNode.setAttributedTitle("".withFont(Font.sys(size: 12)).withTextColor(Color.color6),
                                                 for: UIControlState.normal)
        
        self.replyButtonNode.setAttributedTitle("".withFont(Font.sys(size: 12)).withTextColor(Color.color6),
                                                for: UIControlState.normal)
    }
    
}
