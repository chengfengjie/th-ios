//
//  BaseViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVProgressHUD

class BaseViewController<ViewModel: BaseViewModel>: UIViewController, CustomNavigationBarProtocol {
    
    let content: UIView = UIView.init()
    
    lazy var customeNavBar: CustomNavBar = {
        return self.makeCustomNavigationBar()
    }()
    
    let viewModel: ViewModel!
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    var hud: MBProgressHUD!
    
    var errorHUD: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.content)
        self.content.frame = self.view.bounds
        
        hud = MBProgressHUD.init(view: self.view)
        hud.backgroundView.style = .solidColor
        self.view.addSubview(hud)
        
        errorHUD = MBProgressHUD.init(view: self.view)
        errorHUD.mode = .text
        self.view.addSubview(errorHUD)
        
        self.setNavigationBarHidden(isHidden: false)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.viewModel.viewModelDidLoad()
        }
    }
    
    func bindViewModel() {
        
        viewModel.isRequest.signal.observeValues { [weak self] (isRequest) in
            if isRequest {
                self?.hud.show(animated: true)
            } else {
                self?.hud.hide(animated: true)
            }
        }
                
        viewModel.requestError.signal.observeValues { [weak self] (error) in
            guard let err = error else {
                return
            }
            switch err {
            case .forbidden:
                self?.rootPresentLoginController()
            default:
                if !err.localizedDescription.isEmpty {
                    self?.errorHUD.label.text = err.localizedDescription
                    self?.errorHUD.show(animated: true)
                    self?.errorHUD.hide(animated: true, afterDelay: 1.0)
                }
            }
        }
        
        viewModel.okMessage.signal.observeValues { (successMsg) in
            if !successMsg.isEmpty {
                MBProgressHUD.showSuccessHUD(text: successMsg)
            }
        }
    }
    
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
                        self?.handleClickCloseItem()
                    })
            })
        }
    }
    
    func handleClickCloseItem() {
        self.popViewController(animated: true)
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
    
    lazy var navBarSearchItem: UIButton = {
        return self.makeNavBarRightIconItem(iconName: "city_search").then {
            $0.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        }
    }()
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
    func popToRootViewController(animated: Bool) {
        self.rootNavigationController?.popToRootViewController(animated: animated)
    }
    func rootPresent(viewController: UIViewController, animated: Bool) {
        self.rootNavigationController?.present(viewController, animated: animated, completion: nil)
    }
    func rootPresentLoginController() {
        let model = AuthorizeInputCellPhoneViewModel()
        let controller = AuthorizeInputCellphoneController(viewModel: model)
        let root = UINavigationController.init(rootViewController: controller)
        root.isNavigationBarHidden = true
        self.rootPresent(viewController: root, animated: true)
    }
}


