//
//  SelectCityViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SelectCityViewController: BaseTableViewController<SelectCityViewModel>, SelectCityViewLayout {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "城市选择")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.tableNode.view.separatorStyle = .none
        
        self.tableNode.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        
        self.bindViewModel()
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.fetchCityDataAction.values.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.citylist.value.count
        default:
            return 0
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            return ASCellNode.createBlock(cellNode: RecommendCityCellNode())
        } else {
            let cellNode = ASTextCellNode()
            cellNode.textAttributes = [NSAttributedStringKey.font:UIFont.sys(size: 16),
                                       NSAttributedStringKey.foregroundColor: UIColor.color6]
            cellNode.text = self.viewModel.citylist.value[indexPath.row]["catname"].stringValue
            cellNode.accessoryType = .disclosureIndicator
            return ASCellNode.createBlock(cellNode: cellNode)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionTitleSize.height
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.buildSectionTitleHeader(titleText: "推荐")
        } else {
            return self.buildSectionTitleHeader(titleText: "全部城市")
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        self.viewModel.selectCityAction.apply(indexPath).start()
        self.popViewController(animated: true)
    }
}
