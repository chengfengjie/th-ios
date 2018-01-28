//
//  SpecialTopicListController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SpecialTopicListController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "专题列表")
        
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return SpecialListCellNode()
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(viewController: SpecialTopicViewController(style: .grouped))
    }
}
