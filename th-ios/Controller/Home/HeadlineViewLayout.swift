//
//  HeadlineViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/20.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import JYCarousel

struct HeadlineViewTableNodeHeader {
    var container: UIView
    var carousel: JYCarousel
    init(container: UIView, carousel: JYCarousel) {
        self.container = container
        self.carousel = carousel
    }
}

protocol HeadlineViewControllerLayout {
    var tableNodeHeader: HeadlineViewTableNodeHeader { get }
}
extension HeadlineViewControllerLayout where Self: HeadlineViewController {
    private var testImageArray: [URL] {
        if let url = URL.init(string: "http://a.hiphotos.baidu.com/image/pic/item/500fd9f9d72a6059f550a1832334349b023bbae3.jpg") {
            return [url]
        }
        return []
    }
    var menuItemSize: CGSize {
        return CGSize.init(width: 40, height: 40)
    }
    var menuBarHeight: CGFloat {
        return 70
    }
    var carouseBounds: CGRect {
        let proportion: CGFloat = 1.0 / 2.0
        let height: CGFloat = self.window_width * proportion
        return CGRect.init(x: 0, y: 0, width: self.window_width, height: height)
    }
    var tableNodeHeaderBounds: CGRect {
        let height: CGFloat = self.carouseBounds.height + self.menuBarHeight
        return CGRect.init(x: 0, y: 0, width: self.window_width, height: height)
    }
    func makeTableNodeHeader() -> HeadlineViewTableNodeHeader {
        let container: UIView = UIView()
        container.frame = self.tableNodeHeaderBounds
        
        let carouselView: JYCarousel = JYCarousel.init(frame: self.carouseBounds, configBlock: { (make) -> JYConfiguration? in
            return make
        }) { (clickIndex) in
            
        }
        
        container.addSubview(carouselView)

        carouselView.start(with: NSMutableArray.init(array: self.testImageArray))
        
        let menuBar: UIView = UIView().then { (bar) in
            container.addSubview(bar)
            bar.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(self.menuBarHeight)
            })
        }
        
        let itemWidth: CGFloat = self.menuItemSize.width
        let leftInset: CGFloat = 25
        let interval: CGFloat = (self.window_width - leftInset * 2.0 - itemWidth * 4.0) / 3.0
        
        let leaderboardsButton: UIButton = createMenuButton(title: "排行", color: UIColor.hexColor(hex: "a6dde8"))
        leaderboardsButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(leftInset)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(menuBar.snp.centerY)
            })
        }

        let authorButton: UIButton = createMenuButton(title: "作者", color: UIColor.hexColor(hex: "bca5f1"))
        authorButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(leaderboardsButton.snp.right).offset(interval)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(leaderboardsButton.snp.centerY)
            })
        }
        
        let specialButton: UIButton = createMenuButton(title: "专题", color: UIColor.hexColor(hex: "f7d661"))
        specialButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(authorButton.snp.right).offset(interval)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(leaderboardsButton.snp.centerY)
            })
        }

        let treeHoleButton: UIButton = createMenuButton(title: "树洞", color: UIColor.hexColor(hex: "b2e183"))
        treeHoleButton.do { (item) in
            menuBar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(specialButton.snp.right).offset(interval)
                make.width.height.equalTo(itemWidth)
                make.centerY.equalTo(leaderboardsButton.snp.centerY)
            })
        }
        
        return HeadlineViewTableNodeHeader.init(container: container,
                                                carousel: carouselView)
    }
    
    private func createMenuButton(title: String, color: UIColor) -> UIButton {
        return UIButton.init(type: UIButtonType.custom).then({ (item) in
            item.setTitle(title, for: UIControlState.normal)
            item.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            item.layer.cornerRadius = self.menuItemSize.width / 2.0
            item.layer.backgroundColor = color.cgColor
        })
    }
}
