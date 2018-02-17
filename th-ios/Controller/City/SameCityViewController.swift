//
//  SameCityViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityViewController: BaseTableViewController<SameCityViewModel>, MagicContentLayoutProtocol, CarouselTableHeaderProtocol {
    
    lazy var tableNodeHeader: CarouseTableNodeHeader = {
        return self.makeCarouseHeaderBox()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
        
        self.bindViewModel()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.fetchDataAction.apply(0).start()
        
        viewModel.fetchDataAction.values.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        
        viewModel.adUrlArrayProperty.signal.observeValues { [weak self] (array) in
            self?.tableNodeHeader.carouse.start(with: array)
        }
    }

    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articlelistProperty.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let data: JSON = viewModel.articlelistProperty.value[indexPath.row]
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
        return viewModel.adlistProperty.value.isEmpty ? 0.1 : self.carouseBounds.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.adlistProperty.value.isEmpty ? nil : self.tableNodeHeader.container
    }
}
