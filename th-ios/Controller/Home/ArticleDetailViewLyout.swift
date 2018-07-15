//
//  ArticleDetailViewLyout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import MBProgressHUD

class ArticleDetailViewElement {
    var moreButton: UIButton!
    var shareLabel: UILabel!
    var shareIcon: UIImageView!
    var shareButton: UIButton!
    var collectLabel: UILabel!
    var collectIcon: UIImageView!
    var collectButton: UIButton!
    
    var moreMenuContainer: UIView?
    
    var isShowMoreMenu: Bool = false
}

protocol ArticleDetailViewLayout: ReaderLayout {
    var element: ArticleDetailViewElement { get }
}

extension ArticleDetailViewLayout where Self: ArticleDetailViewController {
    
    func createNavigationBarMenus() -> ArticleDetailViewElement {
        
        let element: ArticleDetailViewElement = ArticleDetailViewElement()
        
        element.moreButton = UIButton.init(type: .custom).then { (item) in
            self.customeNavBar.navBarContent.addSubview(item)
            item.setImage(UIImage.init(named: "more"), for: .normal)
            item.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
            item.snp.makeConstraints({ (make) in
                make.width.height.equalTo(35)
                make.centerY.equalTo(self.customeNavBar.navBarContent.snp.centerY)
                make.right.equalTo(-13)
            })
        }
        
        element.shareLabel = UILabel.init().then({ (label) in
            self.customeNavBar.navBarContent.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.customeNavBar.navBarContent.snp.centerY)
                make.right.equalTo(element.moreButton.snp.left).offset(-18)
            })
            label.font = UIFont.sys(size: 13)
            label.textColor = UIColor.color6
            label.text = ""
        })
        
        element.shareIcon = UIImageView.init().then({ (image) in
            self.customeNavBar.navBarContent.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.right.equalTo(element.shareLabel.snp.left).offset(0)
                make.width.height.equalTo(22)
                make.centerY.equalTo(self.customeNavBar.navBarContent.snp.centerY)
            })
            image.image = UIImage.init(named: "share_icon")
        })
        
        element.collectLabel = UILabel.init().then({ (label) in
            self.customeNavBar.navBarContent.addSubview(label)
            label.font = UIFont.sys(size: 13)
            label.textColor = UIColor.color6
            label.text = ""
            label.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.customeNavBar.navBarContent.snp.centerY)
                make.right.equalTo(element.shareIcon.snp.left).offset(-18)
                
            })
        })
        
        element.collectIcon = UIImageView.init().then({ (image) in
            self.customeNavBar.navBarContent.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.right.equalTo(element.collectLabel.snp.left).offset(0)
                make.width.height.equalTo(22)
                make.centerY.equalTo(self.customeNavBar.navBarContent.snp.centerY)
            })
            image.image = UIImage.init(named: "collect_icon")
            image.highlightedImage = UIImage.init(named: "collect_icon_selected")
        })
        
        element.collectButton = UIButton.init(type: .custom).then({ (btn) in
            self.customeNavBar.navBarContent.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(element.collectIcon.snp.left).offset(-5)
                make.top.equalTo(element.collectIcon.snp.top).offset(-5)
                make.bottom.equalTo(element.collectIcon.snp.bottom).offset(5)
                make.right.equalTo(element.collectLabel.snp.right).offset(5)
            })
        })
        
        element.shareButton = UIButton.init(type: .custom).then({ (btn) in
            self.customeNavBar.navBarContent.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(element.shareIcon.snp.left).offset(-5)
                make.top.equalTo(element.shareIcon.snp.top).offset(-5)
                make.bottom.equalTo(element.shareIcon.snp.bottom).offset(5)
                make.right.equalTo(element.shareLabel.snp.right).offset(5)
            })
        })
        
        return element
    }
    
    func presentMoreMenus() {
        if self.element.moreMenuContainer == nil {
            self.element.moreMenuContainer = MoreMenu().then { (box) in
                self.view.addSubview(box)
                box.frame = CGRect.init(x: self.view.frame.width - 125, y: 35, width: 110, height: 50)
                box.backgroundColor = UIColor.white
                
                box.signal.observeValues({ [weak self] (row) in
                    self?.clickWebsite()
                })
            }
        } else {
            self.view.addSubview(self.element.moreMenuContainer!)
        }
        
        self.element.moreMenuContainer?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        
        self.element.moreMenuContainer?.transform = CGAffineTransform.init(scaleX: 1, y: 0)
        UIView.animate(withDuration: 0.2) {
            self.element.moreMenuContainer?.transform = CGAffineTransform.identity
        }

        self.element.isShowMoreMenu = true
    }
    
    func dismissMoreMenus() {
        if self.element.isShowMoreMenu {
            self.element.isShowMoreMenu = false
            self.element.moreMenuContainer?.removeFromSuperview()
        }
    }
    
}

class ArticleContentCellNode: ReaderContentCellNode {

    var followAction: Action<(), JSON, HttpError>?
    
    var cancelFollowAction: Action<(), JSON, HttpError>?
    
    var authorAction: Action<(), AuthorViewModel, NoError>?
    
    var feedbackAction: Action<(), FeedbackViewModel, NoError>?
    
    var shareAction: Action<JSON, JSON, NoError>?
    
    var isFollow: Bool = false
    
    var articleID: String = ""
    
    var model: ArticleDetailViewModel? = nil
    
    override init(dataJSON: JSON) {
        super.init(dataJSON: dataJSON)
        
        self.attendButtonNode.addTarget(
            self, action: #selector(self.handleFollowAuthor),
            forControlEvents: .touchUpInside)
        
        self.isFollow = dataJSON["isAttentionAuthor"].boolValue
        
        self.authorAvatarImageNode.addTarget(
            self, action: #selector(self.handleAuthor),
            forControlEvents: .touchUpInside)
        
        self.sourceContainer.addTarget(
            self, action: #selector(self.handleAuthor),
            forControlEvents: .touchUpInside)
        
        self.feedbackTextNode.addTarget(
            self, action: #selector(self.handleFeedback),
            forControlEvents: .touchUpInside)
        
        self.updateFollowState()
    }
    
    @objc func handleFollowAuthor() {
        if self.isFollow {
            self.cancelFollowAction?.apply(()).start()
            self.isFollow = false
        } else {
            self.followAction?.apply(()).start()
            self.isFollow = true
        }
        self.updateFollowState()
    }
    
    @objc func handleAuthor() {
        self.authorAction?.apply(()).start()
    }
    
    func updateFollowState() {
        if isFollow {
            self.attendButtonNode.setAttributedTitle("取消关注"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.color9), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.color9.cgColor
            self.attendButtonNode.borderWidth = 1
        } else {
            self.attendButtonNode.setAttributedTitle("关注作者"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.pink), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.pink.cgColor
            self.attendButtonNode.borderWidth = 1
        }
    }
    
    @objc func handleFeedback() {
        self.feedbackAction?.apply(()).start()
    }
    
    override func clickMenuEdit() {
        if let element = self.currentContentElement {
            if UserModel.current.isLogin.value {
                let model = AddEditNoteViewModel(paraContent: element.data, aid: self.articleID)
                self.rootPresent(viewController: AddEditNoteViewController(viewModel: model), animated: true)
                model.callBackSignal.observeValues({ (text) in

                })
            } else {
                self.rootPresentLoginController()
            }
        }
    }
    
    override func clickMenuMoreNote() {
        if let element = self.currentContentElement {
            print(element.data)
            if UserModel.current.isLogin.value {
                let model = ArticleNoteListViewModel.init(sectionData: element.data)
                self.rootPresent(viewController: ArticleNoteListViewController(viewModel: model), animated: true)
            } else {
                self.rootPresentLoginController()
            }
        }
    }
    
    override func clickMenuCopy() {
        if let element = self.currentContentElement {
            UIPasteboard.general.string = element.data["text"].stringValue
            self.model?.okMessage.value = "复制成功"
            element.node.backgroundColor = UIColor.white
        }
        self.hideMenu()
    }
    
    override func editMenuDidShow() {
    }
    
    override func clickMenuShare() {
        if let element = self.currentContentElement {
            self.shareAction?.apply(element.data).start()
        }
    }
}

class ArticleRelatedCellNode: NoneContentArticleCellNodeImpl {
 
    let dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.showCateTextNode = false
        
        self.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withTextColor(Color.color3)
            .withFont(Font.thin(size: 18))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        self.titleTextNode.maximumNumberOfLines = 2
        self.titleTextNode.truncationMode = .byTruncatingTail
        
        self.sourceIconImageNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        self.sourceIconImageNode.defaultImage = UIImage.defaultImage
        
        self.sourceTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color3)
        
        self.unlikeButtonNode.setAttributedTitle("不喜欢"
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color6), for: UIControlState.normal)
        
        self.imageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        self.imageNode.defaultImage = UIImage.defaultImage
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.dataJSON["pic"].stringValue.isEmpty {
            return self.buildNoneImageLayoutSpec(constrainedSize: constrainedSize)
        } else {
            return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
        }
    }
}

fileprivate class MoreMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var signal: Signal<Int, NoError>!
    
    private var observer: Signal<Int, NoError>.Observer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
        
        let (signal, observer) = Signal<Int, NoError>.pipe()
        self.signal = signal
        self.observer = observer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: .default, reuseIdentifier: "")
        setupCell(cell: cell, iconName: "website")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func setupCell(cell: UITableViewCell, iconName: String) {
        
        cell.selectionStyle = .none
        
        let icon: UIImageView = UIImageView.init().then { (icon) in
            cell.contentView.addSubview(icon)
            icon.snp.makeConstraints({ (make) in
                make.left.equalTo(5)
                make.width.height.equalTo(14)
                make.centerY.equalTo(cell.contentView.snp.centerY)
            })
            icon.image = UIImage.init(named: iconName)
        }
        
        UILabel().do { (l) in
            cell.contentView.addSubview(l)
            l.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.right).offset(15)
                make.centerY.equalTo(icon.snp.centerY)
            })
            l.text = "查看原文"
            l.font = UIFont.sys(size: 13)
            l.textColor = UIColor.color6
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.observer.send(value: indexPath.row)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

