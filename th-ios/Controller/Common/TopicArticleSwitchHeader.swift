//
//  TopicArticleSwitchHeader.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

@objc protocol TopicArticleSwitchHeaderLayout {
    var topicArticleSwitchHeader: UIView { get }
    @objc func handleTopicArticleSwitchItemClick(itemIndex: NSNumber)
}
extension TopicArticleSwitchHeaderLayout {
    
    var topicArticleSwitchHeaderSize: CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 50)
    }
    
    private var switchItemSize: CGSize {
        return CGSize.init(width: 50, height: 35)
    }
    
    func makeTopicArticleSwitchHeader() -> UIView {
        let header: UIView = UIView()
        
        let topicButton: UIButton = self.createSwitchItem(title: "话题").then {
            header.addSubview($0)
            $0.isSelected = true
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.bottom.equalTo(0)
                make.height.equalTo(self.switchItemSize.height)
            })
        }
        
        let articleButton = self.createSwitchItem(title: "文章").then {
            header.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(topicButton.snp.right).offset(25)
                make.bottom.equalTo(0)
                make.height.equalTo(self.switchItemSize.height)
            })
        }
        
        let bottomline = UIView().then {
            header.addSubview($0)
            $0.backgroundColor = UIColor.pink
            $0.snp.makeConstraints({ (make) in
                make.bottom.equalTo(0)
                make.width.equalTo(35)
                make.height.equalTo(2)
                make.centerX.equalTo(topicButton.snp.centerX)
            })
        }
        
        topicButton.reactive.controlEvents(.touchUpInside).observe { [weak self] (event) in
            articleButton.isSelected = false
            self?.changeBottomLine(line: bottomline, item: event.value!, index: 0)
        }
        articleButton.reactive.controlEvents(.touchUpInside).observe { [weak self] (event) in
            topicButton.isSelected = false
            self?.changeBottomLine(line: bottomline, item: event.value!, index: 1)
        }
        return header
    }
    
    private func changeBottomLine(line: UIView, item: UIButton, index: Int) {
//        self.performSelector(onMainThread: #selector(self.handleTopicArticleSwitchItemClick(itemIndex:)),
//                             with: NSNumber.init(value: index),
//                             waitUntilDone: true)
        
        item.isSelected = true
        line.snp.remakeConstraints { (make) in
            make.bottom.equalTo(0)
            make.width.equalTo(35)
            make.centerX.equalTo(item.snp.centerX)
            make.height.equalTo(2)
        }
        UIView.animate(withDuration: 0.2) {
            line.superview?.layoutIfNeeded()
        }
    }
    
    private func createSwitchItem(title: String) -> UIButton {
        return UIButton.init(type: .custom).then {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.setTitle(title, for: UIControlState.normal)
            $0.setTitleColor(UIColor.color3, for: UIControlState.normal)
            $0.setTitleColor(UIColor.pink, for: UIControlState.selected)
        }
    }
    
}
