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
    
    let viewModel: HomeArticleViewModel
    
    init(cateInfo: JSON) {
        self.viewModel = HomeArticleViewModel.init(cateInfo: cateInfo)
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
        
        self.bind()
    }
    
    func bind() {
        
        self.viewModel.reactive.signal(forKeyPath: "articleData").observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        
    }
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.articleData.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let data: JSON = self.viewModel.articleData[indexPath.row] as! JSON
        
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
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 80),
                                max: CGSize.init(width: self.window_width, height: 900))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.adData.isEmpty ? 0.1 : self.carouseBounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewModel.adData.isEmpty ? nil : self.tableNodeHeader.container
    }    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

