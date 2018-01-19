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
            $0.view.rowHeight = 0
            $0.view.sectionHeaderHeight = 0
            $0.view.sectionFooterHeight = 0
            print($0.view)
            
            $0.contentInset = UIEdgeInsets.init().with({ (inset) in
                inset.top = CGFloat.init(self.height_navContentBar)
                inset.bottom = CGFloat.init(self.height_tabbarContent)
                inset.left = 0
                inset.right = 0
            })
            self.content.addSubnode($0)
            $0.frame = self.view.bounds
        }
    }

    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let node = ASTextCellNode.init()
            node.text = indexPath.description
            return node
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize.init(width: self.view.frame.width, height: 60))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

