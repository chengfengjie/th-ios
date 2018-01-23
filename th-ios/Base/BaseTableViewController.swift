//
//  BaseTableViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController, ASTableDelegate, ASTableDataSource {

    var tableNode: ASTableNode
    init(style: UITableViewStyle) {
        self.tableNode = ASTableNode.init(style: style)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return 20
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let node = ASTextCellNode.init()
            node.text = indexPath.description
            return node
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 60),
                                max: CGSize.init(width: self.window_width, height: 3000))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

