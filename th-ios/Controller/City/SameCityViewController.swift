//
//  SameCityViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityViewController: BaseTableViewController, MagicContentLayoutProtocol, CarouselTableHeaderProtocol {
    
    lazy var tableNodeHeader: CarouseTableNodeHeader = {
        return self.makeCarouseHeaderBox()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(viewController: ArticleDetailViewController())
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return ArticleListCellNode()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.carouseBounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableNodeHeader.container
    }
}
