//
//  ArticleDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift
import WebKit
import SafariServices

class ArticleDetailViewController: BaseTableViewController<ArticleDetailViewModel>, ArticleDetailViewLayout, SFSafariViewControllerDelegate {
    
    var articleContentCellNode: ArticleContentCellNode? = nil
    
    lazy var bottomBar: ReaderBottomBar = {
        return self.makeAndLayoutReaderBottomBar()
    }()
    
    lazy var element: ArticleDetailViewElement = {
        return self.createNavigationBarMenus()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "")
        
        self.view.backgroundColor = UIColor.white
                
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        element.moreButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (sender) in
            self?.presentMoreMenus()
        }
        
        element.collectButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (sender) in
            self?.viewModel.collectArticleAction.apply(()).start()
        }
        
        viewModel.fetchArticleDataAction.apply(()).start()
        
        viewModel.articleData.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadData()
        }
        
        viewModel.isCollect.signal.observeValues { [weak self] (flag) in
            self?.updateStatus()
        }
        
        viewModel.islike.signal.observeValues { [weak self] (flag) in
            self?.updateStatus()
        }

        viewModel.commentTotal.signal.observeValues { [weak self] (flag) in
            self?.updateStatus()
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
        
        element.shareButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (sender) in
            self?.handleShareButton()
        }
        
        viewModel.shareAction.values.observeValues { [weak self] (data) in
            self?.shareSection(data: data)
        }
    }
    
    func handleShareButton() {
        let title: String = self.viewModel.articleData.value["title"].stringValue
        let text: String = self.viewModel.articleData.value["description"].stringValue
        let url: String = self.viewModel.articleData.value["sourceUrl"].stringValue
        let model: ShareViewModel = ShareViewModel()
        self.rootPresent(viewController: ShareViewController.create(viewModel: model), animated: true)
        model.shareAction.values.observeValues { (type) in
            switch type {
            case .wxFriend:
                ShareUtil.shareToWxFriendToTextInfo(title: title, text: text, url: url)
            case .wxTimeline:
                ShareUtil.shareToWxTimelineTextInfo(title: title, text: text, url: url)
            case .qqFriend:
                ShareUtil.shareToQQFriendTextInfo(title: title, text: text, url: url)
            case .copy:
                UIPasteboard.general.string = url
                self.viewModel.okMessage.value = "复制文章链接成功"
            case .more:
                print(type)
            }
        }
    }
    
    func shareSection(data: JSON) {
        print(data)
        let title: String = self.viewModel.articleData.value["title"].stringValue
        let text: String = data["text"].stringValue
        let url: String = self.viewModel.articleData.value["sourceUrl"].stringValue
        let model: ShareViewModel = ShareViewModel()
        self.rootPresent(viewController: ShareViewController.create(viewModel: model), animated: true)
        model.shareAction.values.observeValues { (type) in
            switch type {
            case .wxFriend:
                ShareUtil.shareToWxFriendToTextInfo(title: title, text: text, url: url)
            case .wxTimeline:
                ShareUtil.shareToWxTimelineTextInfo(title: title, text: text, url: url)
            case .qqFriend:
                ShareUtil.shareToQQFriendTextInfo(title: title, text: text, url: url)
            case .copy:
                UIPasteboard.general.string = text
                self.viewModel.okMessage.value = "复制成功"
            case .more:
                print(type)
            }
        }
    }
    
    func updateStatus() {
        if !self.viewModel.articleData.value.isEmpty {
            self.element.collectIcon.isHighlighted = self.viewModel.isCollect.value
            self.bottomBar.goodItem.isSelected = self.viewModel.islike.value
            self.bottomBar.commentTotalItem.setTitle(self.viewModel.commentTotal.value.description + "评论", for: .normal)
        }
    }
    
    func clickWebsite() {
        if !self.viewModel.articleData.value.isEmpty {
            let sourceUrl: String = self.viewModel.articleData.value["sourceUrl"].stringValue;
            let safari = SFSafariViewController.init(url: URL.init(string: sourceUrl)!, entersReaderIfAvailable: true)
            self.rootPresent(viewController: safari, animated: true)
        }
        self.dismissMoreMenus()
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.viewModel.articleData.value.isEmpty ? 0 : 1
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.articleData.value.isEmpty ? 0 : 1
        } else if section == 1 {
            return 0
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
            cellNode.articleID = self.viewModel.articleID
            cellNode.model = self.viewModel
            cellNode.shareAction = self.viewModel.shareAction
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
        self.dismissMoreMenus()
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
                UIPasteboard.general.string = ShareInfo.appstoreUrl
                self.viewModel.okMessage.value = "复制成功"
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
