//
//  QingModuleViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol QingModuleViewLayout {
    var bannerHeader: QingModuleListBannerHeader { get }
    var menuHeader: (background: UIView, scrollMenu: HorizontalScrollMenu) { get }
}
extension QingModuleViewLayout where Self: QingModuleViewController {
    var bannerHeaderSize: CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 240)
    }
    var menuHeaderSize: CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 70)
    }
    func makeBannerHeader() -> QingModuleListBannerHeader {
        return QingModuleListBannerHeader()
    }
    func makeMenuHeader() -> (UIView, HorizontalScrollMenu) {
        let background: UIView = UIView()
        background.backgroundColor = UIColor.lineColor
        background.frame = CGRect.init(origin: CGPoint.zero, size: self.menuHeaderSize)
        
        UIView().do {
            background.addSubview($0)
            $0.backgroundColor = UIColor.white
            $0.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(15)
            })
        }
        
        let scrollMenu = HorizontalScrollMenu()
        background.addSubview(scrollMenu)
        scrollMenu.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.right.bottom.equalTo(0)
        }
        return (background, scrollMenu)
    }
    
    @discardableResult
    func makePublishTopicButton() -> UIButton {
        return UIButton.init(type: .custom).then {
            self.content.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.bottom.right.equalTo(-20)
                make.width.height.equalTo(40)
            })
            $0.setImage(UIImage.init(named: "qing_publish_icon"), for: UIControlState.normal)
        }
    }
}

class QingModuleListBannerHeader: BaseView {
    
    lazy var backgroundImage: UIImageView = {
        return UIImageView().then {
            self.addSubview($0)
        }
    }()
    
    lazy var maskingView: UIView = {
        return UIView().then {
            self.addSubview($0)
        }
    }()
    
    lazy var titleLabel: UILabel = {
        return UILabel().then {
            self.addSubview($0)
        }
    }()
    
    lazy var infoLabel: UILabel = {
        return UILabel().then {
            self.addSubview($0)
        }
    }()
    
    lazy var descriptionLabel: UILabel = {
        return UILabel().then {
            self.addSubview($0)
        }
    }()
    
    override func setupSubViews() {
        
        self.backgroundImage.yy_imageURL = URL.init(string: "http://d.hiphotos.baidu.com/image/h%3D300/sign=e8687b80a064034f10cdc4069fc27980/622762d0f703918f037f88975a3d269758eec4c5.jpg")
        self.backgroundImage.contentMode = .scaleAspectFill
        self.backgroundImage.layer.masksToBounds = true
        self.backgroundImage.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        self.maskingView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.maskingView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(0)
        }
        
        self.titleLabel.attributedText = "# 辣妈生活 #"
            .withFont(Font.systemFont(ofSize: 20))
            .withTextColor(Color.white)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .center))
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
        
        self.infoLabel.attributedText = "成员: 78W | 话题: 1.2W"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.init(white: 1, alpha: 0.7))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .center))
        self.infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        self.descriptionLabel.attributedText = "雨后的天总是带有微微的潮意，雨后的天空拥有着不同以往的清新的气息，独自一个人漫步在那落叶铺就的叶之路上，一路上听着那窸窸窣窣的声音，一切仿佛都安静下来了，在这里，能感受到每一朵的呼吸声和水滴一滴一滴的低落声。"
            .withTextColor(Color.init(white: 1, alpha: 0.7))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
            .withFont(Font.systemFont(ofSize: 12))
        self.descriptionLabel.numberOfLines = 5
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(self.infoLabel.snp.bottom).offset(20)
        }
        
    }
}


class QingModuleTopListCellNode: ASCellNode, NodeElementMaker {
    
    lazy var buttonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var buttonSize: CGSize = {
        return CGSize.init(width: 60, height: 20)
    }()
    
    var titleWidth: CGFloat {
        return UIScreen.main.bounds.width - self.buttonSize.width - 10 - self.makeDefaultContentInset().left * 2
    }
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.buttonNode.borderColor = UIColor.pink.cgColor
        self.buttonNode.borderWidth = 1
        self.buttonNode.style.preferredSize = self.buttonSize
        self.buttonNode.setAttributedTitle("置顶".withFont(Font.systemFont(ofSize: 12)).withTextColor(Color.pink),
                                           for: UIControlState.normal)
        
        self.titleTextNode.attributedText = "清风过境，带着浓浓的秋意催开了将绽未绽"
            .withFont(Font.systemFont(ofSize: 14))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3))
        
        self.titleTextNode.style.maxWidth = ASDimension.init(unit: ASDimensionUnit.points, value: self.titleWidth)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let hSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                           spacing: 10,
                                           justifyContent: ASStackLayoutJustifyContent.start,
                                           alignItems: ASStackLayoutAlignItems.stretch,
                                           children: [self.buttonNode, self.titleTextNode])
        return ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(10, 20, 0, 20), child: hSpec)
    }
    
}


