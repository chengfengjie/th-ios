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
        
        self.bindViewModel()
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.topicData.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadSections(IndexSet.init(integer: 0), with: .automatic)
        }
        
        viewModel.adData.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadSections(IndexSet.init(integer: 1), with: .automatic)
        }
        
        self.bottomBar.goodItem.backgroundColor = UIColor.white
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 3
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.adData.value.isEmpty ? 0 : 1
        case 2:
            return 10
        default:
            return 0
        }
    }

    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.section {
        case 0:
            return {
                return TopicContentCellNode(dataJSON: self.viewModel.topicData.value)
            }
        case 1:
            return {
                return AdvertisingCellNode(dataJSON: self.viewModel.adData.value)
            }
        case 2:
            return {
                return TopicCommentCellNode()
            }
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

