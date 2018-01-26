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


class LeaderboardsViewCellNode: ASCellNode, LeaderboardsViewCellNodeLayout {
    lazy var categoryTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var imageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var sourceIconImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var sourceTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var unlikeButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()

    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.sourceIconImageNode.style.preferredSize = CGSize.init(width: 14, height: 14)
        
        self.categoryTextNode.attributedText = "小学教育".attributedString
        self.titleTextNode.attributedText = "赵薇和他背后的隐秘富豪".attributedString
        self.imageNode.url = URL.init(string: "http://a.hiphotos.baidu.com/image/h%3D300/sign=c17af2b3bb51f819ee25054aeab54a76/d6ca7bcb0a46f21f46612acbfd246b600d33aed5.jpg")
        self.sourceIconImageNode.url = URL.init(string: "http://c.hiphotos.baidu.com/image/h%3D300/sign=6d0bf83bda00baa1a52c41bb7711b9b1/0b55b319ebc4b745b19f82c1c4fc1e178b8215d9.jpg")
        self.sourceTextNode.attributedText = "21世纪".attributedString
        self.unlikeButtonNode.setAttributedTitle("不喜欢".attributedString, for: UIControlState.normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildNoneImageLayoutSpec(constrainedSize: constrainedSize)
    }
}

protocol LeaderboardsViewCellNodeLayout: CellNodeElementLayout {
    var categoryTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var imageNode: ASNetworkImageNode { get }
    var sourceIconImageNode: ASNetworkImageNode { get }
    var sourceTextNode: ASTextNode { get }
    var unlikeButtonNode: ASButtonNode { get }
}
extension LeaderboardsViewCellNodeLayout {
    
    var contentInset: UIEdgeInsets {
        return kContentInset
    }
    
    func buildNoneImageLayoutSpec(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let sourceSpec = ASStackLayoutSpec.init(direction: .horizontal,
                                                spacing: 5,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [self.sourceIconImageNode, self.sourceTextNode])
        let bottomBarSpec = ASStackLayoutSpec.init(direction: .horizontal,
                                                   spacing: 0,
                                                   justifyContent: .spaceBetween,
                                                   alignItems: .center,
                                                   children: [sourceSpec, self.unlikeButtonNode])
        let mainSpec = ASStackLayoutSpec.init(direction: .vertical,
                                              spacing: 15,
                                              justifyContent: .start,
                                              alignItems: .stretch,
                                              children: [self.categoryTextNode, self.titleTextNode, bottomBarSpec])
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
        return mainInsetSpec
    }
    
}

class HeaderChangeControl: BaseView {
    
    private var items: [UIButton] = []
    
    var titles: [String] = [] {
        didSet {
            self.updateSubviews()
        }
    }
    
    private var bottomline: UIView = UIView()
    
    private func updateSubviews() {
        self.backgroundColor = UIColor.white
        self.items.forEach {
            $0.removeFromSuperview()
        }
        self.items.removeAll()
        var temp: UIButton? = nil
        for item in self.titles {
            self.items.append(UIButton.init(type: .custom).then {
                $0.setTitle(item, for: UIControlState.normal)
                $0.setTitleColor(UIColor.color6, for: UIControlState.normal)
                $0.setTitleColor(UIColor.pink, for: UIControlState.selected)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                self.addSubview($0)
                $0.snp.makeConstraints({ (make) in
                    make.top.bottom.equalTo(0)
                    if temp == nil {
                        make.left.equalTo(0)
                    } else {
                        make.left.equalTo(temp!.snp.right)
                        make.width.equalTo(temp!.snp.width)
                    }
                    if item == self.titles.last {
                        make.right.equalTo(0)
                    }
                })
                $0.addTarget(self, action: #selector(self.handleClickItem(sender:)),
                             for: UIControlEvents.touchUpInside)
                temp = $0
            })
        }
        
        self.items[0].isSelected = true
        
        self.addSubview(bottomline)
        bottomline.snp.remakeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(2)
            make.centerX.equalTo(self.items[0].snp.centerX)
            make.bottom.equalTo(0)
        }
        bottomline.backgroundColor = UIColor.pink
    }
    
    @objc func handleClickItem(sender: UIButton) {
        self.items.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
        self.bottomline.snp.remakeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(2)
            make.centerX.equalTo(sender.snp.centerX)
            make.bottom.equalTo(0)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}



