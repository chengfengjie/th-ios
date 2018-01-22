//
//  HomeCategoryViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HomeCategoryViewController: BaseTableViewController, MagicContentLayoutProtocol, CarouselTableHeaderProtocol {
    
    lazy var tableNodeHeader: CarouseTableNodeHeader = {
        return self.makeCarouseHeaderBox()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
        
    }

    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return ArticleListCellNode()
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 80),
                                max: CGSize.init(width: self.window_width, height: 900))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.carouseBounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableNodeHeader.container
    }    
}
