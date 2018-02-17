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
        background.backgroundColor = UIColor.defaultBGColor
        background.frame = CGRect.init(origin: CGPoint.zero, size: self.menuHeaderSize)
        
        let scrollMenu = HorizontalScrollMenu()
        background.addSubview(scrollMenu)
        scrollMenu.snp.makeConstraints { (make) in
            make.top.equalTo(15)
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
        
        self.backgroundImage.contentMode = .scaleAspectFill
        self.backgroundImage.layer.masksToBounds = true
        self.backgroundImage.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        self.maskingView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.maskingView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(0)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
        
        self.infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        self.descriptionLabel.numberOfLines = 5
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(self.infoLabel.snp.bottom).offset(20)
        }
    }
    
    func updateData(dataJSON: JSON) {
        self.backgroundImage.yy_setImage(with: URL.init(string: dataJSON["banner"].stringValue),
                                         placeholder: UIImage.defaultImage)
        
        self.titleLabel.attributedText = "# \(dataJSON["name"].stringValue)"
            .withFont(Font.systemFont(ofSize: 20))
            .withTextColor(Color.white)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .center))
        
        self.infoLabel.attributedText = "成员: \(dataJSON["favtimes"].stringValue) | 话题: \(dataJSON["threads"].stringValue)"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.init(white: 1, alpha: 0.7))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .center))
        
        self.descriptionLabel.attributedText = dataJSON["description"].stringValue
            .withTextColor(Color.init(white: 1, alpha: 0.7))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
            .withFont(Font.systemFont(ofSize: 12))
        
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
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.buttonNode.borderColor = UIColor.pink.cgColor
        self.buttonNode.borderWidth = 1
        self.buttonNode.style.preferredSize = self.buttonSize
        self.buttonNode.setAttributedTitle("置顶".withFont(Font.systemFont(ofSize: 12)).withTextColor(Color.pink),
                                           for: UIControlState.normal)
        
        self.titleTextNode.attributedText = dataJSON["subject"].stringValue
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


