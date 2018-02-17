//
//  ArticleDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleDetailViewController: BaseTableViewController<ArticleDetailViewModel>, ArticleDetailViewLayout {
    
    lazy var bottomBar: ReaderBottomBar = {
        return self.makeAndLayoutReaderBottomBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "文章详情")
        
        self.view.backgroundColor = UIColor.white
                
        self.tableNode.view.separatorStyle = .none
    }
    
    override func bindViewModel() {
        
//        self.viewModel.reactive
//            .signal(forKeyPath: "data")
//            .observeResult { [weak self] (res) in
//                self?.tableNode.reloadData()
//        }
//
//        self.viewModel.reactive.signal(forKeyPath: "adData")
//            .skipNil().observeValues { [weak self] (val) in
//            self?.tableNode.reloadData()
//        }
        
        self.bottomBar.goodItem.reactive
            .controlEvents(.touchUpInside)
            .observeValues { (sender) in
                print(sender)
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.viewModel.dataJSON.isEmpty ? 0 : 3
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.dataJSON.isEmpty ? 0 : 1
        } else if section == 1 {
            return 1
        } else {
            return self.viewModel.relatedlist.count
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            return {
                return ArticleContentCellNode(dataJSON: self.viewModel.dataJSON)
            }
        } else if indexPath.section == 1 {
            return {
                return AdvertisingCellNode(dataJSON: self.viewModel.adJSONData)
            }
        } else {
            return {
                return ArticleRelatedCellNode(dataJSON: self.viewModel.relatedlist[indexPath.row])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else if section == 1 {
            return 15
        } else {
            return 15
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return (section == 1 || section == 2) ? UIView().then({ (header) in
            header.backgroundColor = UIColor.defaultBGColor
        }) : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
