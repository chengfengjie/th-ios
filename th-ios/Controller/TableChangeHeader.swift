//
//  TableChangeHeader.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

class HeaderChangeControl: BaseView {
    
    var items: [UIButton] = []
    
    var bottomlineWidth: CGFloat = 80 {
        didSet {
            self.updateSubviews()
        }
    }
    
    var titles: [String] = [] {
        didSet {
            self.updateSubviews()
        }
    }
    
    private var bottomline: UIView = UIView()
    
    private func updateSubviews() {
        if self.items.isEmpty {
            return
        }
        self.backgroundColor = UIColor.white
        self.items.forEach {
            $0.removeFromSuperview()
        }
        self.items.removeAll()
        var temp: UIButton? = nil
        for (index, item) in self.titles.enumerated() {
            self.items.append(UIButton.init(type: .custom).then {
                $0.setTitle(item, for: UIControlState.normal)
                $0.setTitleColor(UIColor.color6, for: UIControlState.normal)
                $0.setTitleColor(UIColor.pink, for: UIControlState.selected)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                $0.tag = 100 + index
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
            make.width.equalTo(bottomlineWidth)
            make.height.equalTo(3)
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
            make.width.equalTo(bottomlineWidth)
            make.height.equalTo(3)
            make.centerX.equalTo(sender.snp.centerX)
            make.bottom.equalTo(0)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
