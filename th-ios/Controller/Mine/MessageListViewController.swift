//
//  MessageListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class MessageListViewController: BaseTableViewController<MessageListViewModel>, MessageListViewLayout {
    
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
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        headerChangeControl.items.forEach {
            $0.reactive.controlEvents(.touchUpInside)
                .observeValues({ [weak self] (sender) in
                    self?.handleClickChangeItem(sender: sender)
                })
        }
        
        viewModel.systemMessagelist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        viewModel.userMessagelist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        viewModel.systemCellNodeAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SystemMessageViewController(viewModel: model))
        }
        viewModel.userMessageCellNodeAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: PrivateMessageViewController(viewModel: model))
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
        switch self.messageType {
        case .systemMessage:
            return self.viewModel.systemMessagelist.value.count
        case .privateMessage:
            return self.viewModel.userMessagelist.value.count
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            switch self.messageType {
            case .systemMessage:
                return SystemMessageListCellNode(dataJSON: self.viewModel.systemMessagelist.value[indexPath.row])
            case .privateMessage:
                return PrivateMessageListCellNode(dataJSON: self.viewModel.userMessagelist.value[indexPath.row])
            }
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
            viewModel.systemCellNodeAction.apply(indexPath).start()
        } else {
            viewModel.userMessageCellNodeAction.apply(indexPath).start()
        }
    }
}
