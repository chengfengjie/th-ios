//
//  SettingViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SettingViewController: BaseTableViewController<SettingViewModel>, SettingViewLayout {
    
    lazy var logoutFooter: (footer: UIView, button: UIButton) = {
        return self.makeLogoutTableFooter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "设置")
        
        self.tableNode.backgroundColor = UIColor.hexColor(hex: "efefef")
        
        self.tableNode.view.separatorStyle = .none
    
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.logoutFooter.button.reactive.pressed = CocoaAction(viewModel.logoutAction)
        self.viewModel.logoutAction.values.observeValues { [weak self] (_) in
            self?.popViewController(animated: false)
        }
        
        viewModel.feedBackAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: FeedbackViewController(viewModel: model))
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            return {
                if indexPath.row == 0 {
                    return SwitchControlCellNode(title: "阅读推送", bottomline: true)
                }
                return IndicatorCellNode(title: "推荐童伙妈妈给好友")
            }
        }
        return {
            switch indexPath.row {
            case 0:
                return IndicatorCellNode(title: "关于童伙妈妈")
            case 1:
                return IndicatorCellNode(title: "反馈&合作")
            case 2:
                return IndicatorCellNode(title: "去App Store评分")
            case 3:
                return IndicatorCellNode(title: "清除缓存")
            case 4:
                return SubtitleCellNode.init(title: "版本", subTitle: "1.0.0")
            default:
                return ASTextCellNode()
            }
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize.init(width: self.window_width, height: 60))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableNodeHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.makeTableNodeHeader(title: section == 0 ? "互动设置" : "其他设置")
    }

    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
                self.viewModel.feedBackAction.apply(()).start()
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.1 : self.logoutFooterHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 0 ? nil : self.logoutFooter.footer
    }
}
