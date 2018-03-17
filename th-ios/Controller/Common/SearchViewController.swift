//
//  SearchViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/20.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class SearchViewController: BaseTableViewController<SearchViewModel>, SearchViewControllerLayout,
UITextFieldDelegate, TopicArticleSwitchHeaderAction {
    
    lazy var searchControl: SearchControl = {
        return self.makeSearchControl()
    }()
    
    lazy var switchHeader: TopicArticleSwitchHeader = {
        return TopicArticleSwitchHeader()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavBarRightCancelButton()
        
        self.searchControl.backgroundColor = UIColor.hexColor(hex: "fafafa")
        
        self.switchHeader.action = self
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        searchControl.textField.delegate = self
        
        viewModel.keyWord <~ searchControl.textField.reactive.continuousTextValues.skipNil()
        
        searchControl.textField.enablesReturnKeyAutomatically = true
        
        viewModel.articlelist.signal.observeValues { [weak self] (val) in
            self?.tableNode.reloadData()
        }
        
        viewModel.articleDetailAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: ArticleDetailViewController(viewModel: model))
        }
    }
    
    func switchDidChange(buttonIndex: Int, header: TopicArticleSwitchHeader) {
        self.viewModel.currentTab.value = buttonIndex.description
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.searchAction.apply(()).start()
        return true
    }
    
    @objc func handleClickCancelItem() {
        self.popViewController(animated: true)
    }

    @objc func handleTopicArticleSwitchItemClick(itemIndex: NSNumber) {
        
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articlelist.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return ASCellNode.createBlock(cellNode: SearchResultCellNode(dataJSON: self.viewModel.articlelist.value[indexPath.row]))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.switchHeader
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.currentTab.value == "1" {
            self.viewModel.articleDetailAction.apply(indexPath).start()
        } else {
            
        }
    }
}

