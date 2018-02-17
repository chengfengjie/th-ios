//
//  MessageListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class MessageListViewController: BaseTableViewController<BaseViewModel>, MessageListViewLayout {
    
    enum MessageType {
        case privateMessage
        case systemMessage
    }
    
    private var messageType: MessageType = .systemMessage
    
    lazy var headerChangeControl: HeaderChangeControl = {
        return self.makeHeaderChangeControl()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "消息")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.headerChangeControl.items.forEach {
            $0.addTarget(self, action: #selector(self.handleClickChangeItem(sender:)),
                         for: .touchUpInside)
        }
    }
    
    @objc func handleClickChangeItem(sender: UIButton) {
        if sender.tag == 100 {
            self.messageType = .systemMessage
        } else {
            self.messageType = .privateMessage
        }
        self.tableNode.reloadData()
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            self.messageType == .privateMessage ? PrivateMessageListCellNode() : SystemMessageListCellNode()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerChangeControlSize.height
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerChangeControl
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if self.messageType == .systemMessage {
//            self.pushViewController(viewController: SystemMessageViewController(style: .grouped))
        } else {
//            self.pushViewController(viewController: PrivateMessageViewController())
        }
    }
}
