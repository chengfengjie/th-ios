//
//  Style.swift
//  th-ios
//
//  Created by chengfj on 2018/1/25.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol StyleParserProtocol {}

extension StyleParserProtocol {
    func createFont(fontJson: JSON) -> UIFont {
        let name: String = fontJson["name"].stringValue
        let size: CGFloat = fontJson["size"].floatValue.cgFloat
        if name == "BST" {
            return UIFont.songTiBold(size: size)
        } else if name == "ST" {
            return UIFont.songTi(size: size)
        } else if name == "B" {
            return UIFont.boldSystemFont(ofSize: size)
        } else if name == "N" {
            return UIFont.systemFont(ofSize: size)
        } else if name == "NF" {
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.thin)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    func createInset(insetJson: JSON) -> UIEdgeInsets {
        return UIEdgeInsets.zero.with {
            $0.left = insetJson["left"].floatValue.cgFloat
            $0.top = insetJson["top"].floatValue.cgFloat
            $0.right = insetJson["right"].floatValue.cgFloat
            $0.bottom = insetJson["bottom"].floatValue.cgFloat
        }
    }
    
    func createColor(hex:String) -> UIColor {
        return UIColor.hexColor(hex: hex)
    }
    
    func createCGSize(json: JSON) -> CGSize {
        return CGSize.init(width: json["width"].floatValue.cgFloat, height: json["height"].floatValue.cgFloat)
    }
    
    func createAlignment(val: String) -> NSTextAlignment {
        if val == "center" {
            return NSTextAlignment.center
        } else if val == "left" {
            return NSTextAlignment.left
        } else if val == "right" {
            return NSTextAlignment.right
        } else if val == "justified" {
            return NSTextAlignment.justified
        } else if val == "natural" {
            return NSTextAlignment.natural
        } else {
            return NSTextAlignment.left
        }
    }
    
    func updateTextStyle(style:TextStyle, json: JSON) {
        style.lineSpacing = json["lineSpacing"].floatValue.cgFloat
        style.alignment = createAlignment(val: json["alignment"].stringValue)
        style.font = createFont(fontJson: json)
        style.color = createColor(hex: json["color"].stringValue)
    }

}

extension AppStyle {
    
    static let styleUrl: String = "http://chengfj.oss-cn-hangzhou.aliyuncs.com/th/th-ui-cfg.json"
    
    static let tabBarIconUrl: String = "http://chengfj.oss-cn-hangzhou.aliyuncs.com/th/tabbar/"
    
    static let local: AppStyle = AppStyle()
    class func fetchUpdateAppStyle() {
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        if let url = URL.init(string: styleUrl) {
            let task: URLSessionDataTask = session.dataTask(with: url, completionHandler: { (data, res, err) in
                if let data = data  {
                    let json = JSON.init(data: data)
                    AppStyle.local.updateStyle(json: json)
                }
            })
            task.resume()
        }
    }
    
    class func loadLocalAppStyle() {
        if let path = Bundle.main.path(forAuxiliaryExecutable: "style.json"),
            let data = NSData.init(contentsOfFile: path) {
            AppStyle.local.updateStyle(json: JSON.init(data: data as Data))
        }
    }
    
    func updateStyle(json: JSON) {
        self.updateTextStyle(style: self.home_top_bar_text_style, json: json["home_top_bar_text_style"])
        self.home_index.update(json: json["home_table_node_cell_style"])
    }
}

class TextStyle: NSObject {
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    var color: UIColor = UIColor.color3
    var lineSpacing: CGFloat = 1
    var alignment: NSTextAlignment = NSTextAlignment.left
}

class AppStyle: NSObject, StyleParserProtocol {
    /// 首页顶部滚动菜单滚动条文字颜色和字体
    var home_top_bar_text_style: TextStyle = TextStyle()
    var home_index: HomeTableNodeCellStyle = HomeTableNodeCellStyle()
    var home_nocontent_article_cell_node: NoneContentArticleCellNodeStyle = NoneContentArticleCellNodeStyle()
}


extension NSObject {
    var css: AppStyle {
        return AppStyle.local
    }
}

protocol MakeStyleProtocol {}

fileprivate func buildParagraphStyle(style: TextStyle) -> NSParagraphStyle {
    return NSMutableParagraphStyle().then {
        $0.lineSpacing = style.lineSpacing
        $0.alignment = style.alignment
    }
}

extension ASTextNode {
    func setText(text: String, style: TextStyle) {
        self.attributedText = text.withFont(style.font)
            .withTextColor(style.color)
            .withParagraphStyle(buildParagraphStyle(style: style))
    }
}

extension UILabel {
    func setText(text: String, style: TextStyle) {
        self.attributedText = text.withFont(style.font)
            .withTextColor(style.color)
            .withParagraphStyle(buildParagraphStyle(style: style))
    }
}

extension UIButton {
    func setTitleText(text: String, style: TextStyle, state: UIControlState) {
        self.setAttributedTitle(text.withTextColor(style.color)
            .withFont(style.font)
            .withParagraphStyle(buildParagraphStyle(style: style)),
                                for: state)
    }
}

extension ASButtonNode {
    func setTitleText(text: String, style: TextStyle, state: UIControlState = .normal) {
        self.setAttributedTitle(text.withTextColor(style.color)
            .withFont(style.font)
            .withParagraphStyle(buildParagraphStyle(style: style)),
                                for: state)
    }
}































