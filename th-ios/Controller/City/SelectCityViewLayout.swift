//
//  SelectCityViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol SelectCityViewLayout {
    
}
extension SelectCityViewLayout where Self: SelectCityViewController {
    var sectionTitleSize: CGSize {
        return CGSize.init(width: self.window_width, height: 50)
    }
    func buildSectionTitleHeader(titleText: String) -> UIView {
        return UIView().then({ (header) in
            UIView.init().do {
                header.addSubview($0)
                $0.snp.makeConstraints({ (make) in
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.centerY.equalTo(header.snp.centerY)
                    make.height.equalTo(1)
                })
                $0.backgroundColor = UIColor.lineColor
            }
            
            UILabel().do {
                
                $0.attributedText = titleText
                    .withFont(Font.systemFont(ofSize: 12))
                    .withTextColor(Color.color3)
                    .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .center))
                
                $0.backgroundColor = UIColor.white
                
                header.addSubview($0)
                $0.snp.makeConstraints({ (make) in
                    make.width.equalTo(80)
                    make.centerY.equalTo(header.snp.centerY)
                    make.centerX.equalTo(header.snp.centerX)
                })
            }
        })
    }
}

class RecommendCityCellNode: ASCellNode, NodeElementMaker {
    
    var dataSource: [(icon: String, name: String)] = [
        ("city_guangzhou", "广州"),
        ("city_shenzheng", "深圳"),
        ("city_beijing", "北京"),
        ("city_chongqing", "重庆"),
        ("city_shanghai", "上海"),
        ("city_hangzhou", "杭州"),
        ("city_zhengzhou", "郑州"),
        ("city_nanjing", "南京"),
    ]
    
    private var items: [[(icon: ASImageNode, name: ASTextNode)]] = []
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        var lineItem: [(icon: ASImageNode, name: ASTextNode)] = []
        self.dataSource.forEach { (data) in
            if lineItem.count == 4 {
                self.items.append(lineItem)
                lineItem = []
            }
            let iconImageNode: ASImageNode = self.makeAndAddImageNode().then {
                $0.image = UIImage.init(named: data.icon)
                $0.style.preferredSize = CGSize.init(width: 45, height: 45)
            }
            let nameTextNode: ASTextNode = self.makeAndAddTextNode().then {
                $0.attributedText = data.name
                    .withFont(Font.systemFont(ofSize: 12))
                    .withTextColor(Color.color3)
            }
            lineItem.append((iconImageNode, nameTextNode))
        }
        if !lineItem.isEmpty {
            self.items.append(lineItem)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var allLineSpec: [ASStackLayoutSpec] = []
        self.items.forEach { (lineItems) in
            var lineIconSpec: [ASStackLayoutSpec] = []
            lineItems.forEach({ (item) in
                let iconSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                      spacing: 10,
                                                      justifyContent: ASStackLayoutJustifyContent.start,
                                                      alignItems: ASStackLayoutAlignItems.center,
                                                      children: [item.icon, item.name])
                lineIconSpec.append(iconSpec)
            })
            
            let lineSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                  spacing: 0,
                                                  justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                  alignItems: ASStackLayoutAlignItems.center,
                                                  children: lineIconSpec)
            allLineSpec.append(lineSpec)
        }
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 30,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: allLineSpec)
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(30, 30, 30, 30), child: mainSpec)
        
    }
    
}
