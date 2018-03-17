//
//  SpecialTopicListController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SpecialListController: BaseTableViewController<SpecialListViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "专题列表")
        
        self.bindViewModel()
        
        self.tableNode.view.separatorStyle = .none
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.fetchlistAction.values.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        
        viewModel.specialDetailAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SpecialViewController(viewModel: model))
        }
        
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.speciallist.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return SpecialListCellNode(dataJSON: self.viewModel.speciallist.value[indexPath.row])
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.specialDetailAction.apply(indexPath).start()
    }
}
