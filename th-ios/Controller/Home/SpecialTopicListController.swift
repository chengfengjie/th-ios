//
//  SpecialTopicListController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SpecialTopicListController: BaseTableViewController {

    let viewModel: SpecialTopicListViewModel = SpecialTopicListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "专题列表")
        
        self.bindViewModel()
    }
    
    func bindViewModel() {
        
        self.viewModel.reactive
            .signal(forKeyPath: "speciallist")
            .observeResult { [weak self] (val) in
                self?.tableNode.reloadData()
        }
        
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.specilaJsonList.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return SpecialListCellNode(dataJSON: self.viewModel.specilaJsonList[indexPath.row])
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(viewController: SpecialTopicViewController(style: .grouped))
    }
}
