//
//  ArticleDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class ArticleDetailViewController: BaseTableViewController<ArticleDetailViewModel>, ArticleDetailViewLayout {
    
    var articleContentCellNode: ArticleContentCellNode? = nil
    
    lazy var bottomBar: ReaderBottomBar = {
        return self.makeAndLayoutReaderBottomBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "文章详情")
        
        self.view.backgroundColor = UIColor.white
                
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.fetchArticleDataAction.apply(()).start()
        
        Signal.combineLatest(viewModel.articleData.signal,
                             viewModel.adData.signal)
            .observeValues { [weak self] (_, _) in
            self?.tableNode.reloadData()
        }
        
        bottomBar.commentTotalItem.reactive.pressed = CocoaAction(viewModel.commentTotalAction)
        viewModel.commentTotalAction.values.observeValues { [weak self] (model) in
            let controller = ArticleCommentListViewController(viewModel: model)
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overCurrentContext
            self?.rootPresent(viewController: controller, animated: true)
        }
        
        bottomBar.commentItem.reactive.pressed = CocoaAction(viewModel.commentAction)
        viewModel.commentAction.values.observeValues { [weak self] (model) in
            let controller = CommentArticleViewController(viewModel: model)
            self?.pushViewController(viewController: controller)
        }
        
        viewModel.commentAction.errors.observeValues { [weak self] (err) in
            self?.rootPresentLoginController()
        }
        
        bottomBar.goodItem.reactive.isSelected <~ viewModel.islike
        
        bottomBar.goodItem.reactive.pressed = CocoaAction(viewModel.likeArticleAction)
        
        viewModel.authorInfoAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: AuthorViewController(viewModel: model))
        }
        
        viewModel.feedbackAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: FeedbackViewController(viewModel: model))
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.viewModel.articleData.value.isEmpty ? 0 : 3
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.articleData.value.isEmpty ? 0 : 1
        } else if section == 1 {
            return 1
        } else {
            return self.viewModel.relatedlist.count
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            let cellNode = ArticleContentCellNode(dataJSON: self.viewModel.articleData.value)
            self.articleContentCellNode = cellNode
            cellNode.followAction = self.viewModel.followAuthorAction
            cellNode.cancelFollowAction = self.viewModel.cancelFollowAuthorAction
            cellNode.authorAction = self.viewModel.authorInfoAction
            cellNode.feedbackAction = self.viewModel.feedbackAction
            cellNode.articleID = self.viewModel.articleID
            cellNode.model = self.viewModel
            cellNode.shareParaImageAction.values.observeValues({ [weak self] (image) in
                self?.shareParaImage(image: image)
            })
            return ASCellNode.createBlock(cellNode: cellNode)
        } else if indexPath.section == 1 {
            let cellNode = AdvertisingCellNode(dataJSON: self.viewModel.adData.value)
            return ASCellNode.createBlock(cellNode: cellNode)
        } else {
            let cellNode = ArticleRelatedCellNode(dataJSON: self.viewModel.relatedlist[indexPath.row])
            return ASCellNode.createBlock(cellNode: cellNode)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else if section == 1 {
            return 15
        } else {
            return 15
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return (section == 1 || section == 2) ? UIView().then({ (header) in
            header.backgroundColor = UIColor.defaultBGColor
        }) : nil
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.articleContentCellNode?.didScroll()
    }
    
    func shareParaImage(image: UIImage) {
        let shareModel: ShareViewModel = ShareViewModel()
        let shareVC: ShareViewController = ShareViewController.create(viewModel: shareModel)
        self.rootPresent(viewController: shareVC, animated: true)
        shareModel.shareAction.values.observeValues { (type) in
            switch type {
            case .qqFriend:
                ShareUtil.shareToQQFriendImage(image: image)
                break
            case .copy:
                break
            case .wxFriend:
                ShareUtil.shareToWxFriendImage(image: image)
                break
            case .wxTimeline:
                ShareUtil.shareToWxTimelineImage(image: image)
                break
            case .more:
                ShareUtil.shareToSystemMore()
                break
            }
        }
    }
}
