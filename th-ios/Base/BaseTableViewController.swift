//
//  BaseTableViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseTableViewController<Model: BaseViewModel>: BaseViewController<Model>, ASTableDelegate, ASTableDataSource {

    var tableNode: ASTableNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(viewModel: Model) {
        self.tableNode = ASTableNode.init(style: UITableViewStyle.grouped)
        super.init(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableNode.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = UIColor.white
            $0.view.sectionHeaderHeight = 0
            $0.view.sectionFooterHeight = 0
            
            $0.contentInset = UIEdgeInsets.init().with({ (inset) in
                inset.top = CGFloat.init(self.height_navBar)
                inset.bottom = CGFloat.init(self.height_tabbarContent)
                inset.left = 0
                inset.right = 0
            })
            self.content.addSubnode($0)
            $0.frame = self.view.bounds
            
            $0.view.separatorColor = UIColor.lineColor
        }
        
        if #available(iOS 11.0, *) {
            self.tableNode.view.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let node = ASTextCellNode.init()
            node.text = indexPath.description
            return node
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 30),
                                max: CGSize.init(width: self.window_width, height: 30000))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

