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
    
    let viewModel: SameCityViewModel
    
    init(cateId: String) {
        self.viewModel = SameCityViewModel(cateID: cateId)
        super.init(style: UITableViewStyle.grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
        
        self.bindViewModel()
    }
    
    func bindViewModel() {
        self.viewModel.reactive
            .signal(forKeyPath: "articlelist")
            .observeValues { [weak self] (value) in
            self?.tableNode.reloadData()
            self?.tableNodeHeader.carouse.start(with: self?.viewModel.advUrllist)
        }
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let dataJSON: JSON = self.viewModel.articlelist[indexPath.row] as! JSON
        self.pushViewController(viewController: ArticleDetailViewController(articleID: dataJSON["aid"].stringValue))
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.articlelist.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let data: JSON = self.viewModel.articlelist[indexPath.row] as! JSON
        let imageUrl: String = data["pic"].stringValue
        if imageUrl.isEmpty {
            return {
                return ArticleListCellNode(dataJSON: data)
            }
        } else {
            return {
                return ArticleListImageCellNode(dataJSON: data)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.advUrllist.count == 0 ? 0.1 : self.carouseBounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewModel.advUrllist.count == 0 ? nil : self.tableNodeHeader.container
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
