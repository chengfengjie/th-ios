//
//  TopicDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/8.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TopicDetailViewController: BaseTableViewController<TopicDetailViewModel>, TopicDetailViewLayout {
    
    lazy var bottomBar: ReaderBottomBar = {
        return self.makeAndLayoutReaderBottomBar()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "话题详情")
        
        self.setNavigationBarCloseItem(isHidden: false)
    
        self.view.backgroundColor = UIColor.white
        
        self.tableNode.view.separatorStyle = .none
        
        self.tableNode.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 50, right: 0)
        
        self.bindViewModel()
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.fetchTopicDetailAction.apply(()).start()
        
        viewModel.topicData.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadData()
        }
        
        viewModel.adData.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadData()
        }
        
        self.bottomBar.goodItem.backgroundColor = UIColor.white
        
        bottomBar.commentItem.reactive.pressed = CocoaAction(viewModel.commentTopicAction)
        viewModel.commentTopicAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: CommentTopicViewController(viewModel: model))
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 3
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.viewModel.topicData.value.isEmpty ? 0 : 1
        case 1:
            return self.viewModel.adData.value.isEmpty ? 0 : 1
        case 2:
            return self.viewModel.topicCommentlist.value.count
        default:
            return 0
        }
    }

    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.section {
        case 0:
            let cellNode = TopicContentCellNode(dataJSON: self.viewModel.topicData.value)
            cellNode.followAction = viewModel.followUserAction
            return ASCellNode.createBlock(cellNode: cellNode)
        case 1:
            let cellNode = AdvertisingCellNode(dataJSON: self.viewModel.adData.value)
            return ASCellNode.createBlock(cellNode: cellNode)
        case 2:
            let cellNode = TopicCommentCellNode(dataJSON: self.viewModel.topicCommentlist.value[indexPath.row])
            return ASCellNode.createBlock(cellNode: cellNode)
        default:
            return {
                return ASCellNode()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 15 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 2 ? UIView().then {
            $0.backgroundColor = UIColor.defaultBGColor
        } : nil
    }
}

