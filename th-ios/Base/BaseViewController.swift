//
//  BaseViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController<ViewModel: BaseViewModel>: UIViewController, CustomNavigationBarProtocol {
    
    let content: UIView = UIView.init()
    
    let viewModel: ViewModel!
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.viewModelDidLoad()
        
        self.view.addSubview(self.content)
        self.content.frame = self.view.bounds
        
        hud = MBProgressHUD.init(view: self.view)
        self.view.addSubview(hud)
        
        self.setNavigationBarHidden(isHidden: false)
    }
    
    func bindViewModel() {
        self.viewModel.isRequest.signal.observeValues { [weak self] (isRequest) in
            if isRequest {
                self?.hud.show(animated: true)
            } else {
                self?.hud.hide(animated: true)
            }
        }
    }
    
    lazy var customeNavBar: CustomNavBar = {
        return self.makeCustomNavigationBar()
    }()
    
    func setNavigationBarHidden(isHidden: Bool) {
        if isHidden {
            self.customeNavBar.navBarBox.isHidden = true
        } else {
            self.customeNavBar.navBarBox.isHidden = false
        }
    }
    
    func setNavigationBarCloseItem(isHidden: Bool) {
        if isHidden {
            self.customeNavBar.closeItem?.removeFromSuperview()
            self.customeNavBar.closeItem = nil
        } else {
            self.makeNavBarLeftIconItem(iconName: "qing_close").do({ (item) in
                self.customeNavBar.closeItem = item
                item.reactive.controlEvents(.touchUpInside)
                    .observe({ [weak self] (signal) in
                        self?.popViewController(animated: true)
                    })
            })
        }
    }
    
    func setNavigationBarTitle(title: String) {
        let titleAttributeText = title.withFont(Font.songTiBold(size: 17)).withTextColor(Color.color3)
        if self.customeNavBar.titleLabel == nil {
            self.customeNavBar.titleLabel = self.makeNavBarAttributeTitle(attributeText: titleAttributeText)
        } else {
            self.customeNavBar.titleLabel?.attributedText = titleAttributeText
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


/// 获取根控制器协议，UIViewController， UIView 可直接获取
protocol RootNavigationControllerProtocol {}
extension UIResponder: RootNavigationControllerProtocol {}
extension RootNavigationControllerProtocol {
    var rootNavigationController: UINavigationController? {
        return AppDelegate.rootNavgationController;
    }
    func pushViewController(viewController: UIViewController, animated: Bool = true) {
        self.rootNavigationController?.pushViewController(viewController, animated: animated)
    }
    func popViewController(animated: Bool) {
        self.rootNavigationController?.popViewController(animated: animated)
    }
}

