//
//  HomeLeaderboardsStyle.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HomeTableNodeCellStyle: StyleParserProtocol  {
    
    var headerItemSize: CGSize = CGSize.init(width: 50, height: 50)
    var bannerHWRatio: Float = 0.5
    var contentInset: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
    var elementSpacing: Float = 10
    var cateTextStyle: TextStyle = TextStyle()
    var titleTextStyle: TextStyle = TextStyle()
    var contentTextStyle: TextStyle = TextStyle()
    var imageSize: CGSize = CGSize.init(width: 70, height: 50)
    var authorIconSize: CGSize = CGSize.init(width: 16, height: 16)
    var authorUnlikeTextStyle: TextStyle = TextStyle()
    
    func update(json: JSON) {
        self.headerItemSize = createCGSize(json: json["headerItemSize"])
        self.bannerHWRatio = json["bannerHWRatio"].floatValue
        self.elementSpacing = json["elementSpacing"].floatValue
        self.contentInset = self.createInset(insetJson: json["contentInset"])
        self.updateTextStyle(style: self.cateTextStyle, json: json["cateTextStyle"])
        self.updateTextStyle(style: self.titleTextStyle, json: json["titleTextStyle"])
        self.updateTextStyle(style: self.contentTextStyle, json: json["contentTextStyle"])
        self.imageSize = self.createCGSize(json: json["imageSize"])
        self.authorIconSize = self.createCGSize(json: json["authorIconSize"])
        self.updateTextStyle(style: self.authorUnlikeTextStyle, json: json["authorUnlikeTextStyle"])
    }
}

class NoneContentArticleCellNodeStyle: StyleParserProtocol {
    var cateNameTextStyle: TextStyle
    var titleTextStyle: TextStyle
    var sourceIconSize: CGSize
    var sourceNameTextStyle: TextStyle
    var imageSize: CGSize
    init() {
        self.cateNameTextStyle = TextStyle().then {
            $0.color = UIColor.color9
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.alignment = .left
        }
        
        self.titleTextStyle = TextStyle().then {
            $0.color = UIColor.color3
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.lineSpacing = 3
        }
        
        self.sourceIconSize = CGSize.init(width: 15, height: 15)
        
        self.sourceNameTextStyle = TextStyle().then {
            $0.color = UIColor.color6
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        self.imageSize = CGSize.init(width: 70, height: 50)
    }
}

