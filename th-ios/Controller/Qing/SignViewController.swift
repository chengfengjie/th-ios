//
//  SignViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/11.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignViewController: BaseViewController<SignViewModel>, SignViewLayout {
    
    lazy var background: UIImageView = {
        return self.makeBackgroundImage()
    }()
    
    lazy var closeItem: UIButton = {
        return self.makeCloseItem()
    }()
    
    lazy var dayLabel: UILabel = {
        return self.makeDayLabel()
    }()

    lazy var infoLabel: UILabel = {
        return self.makeInfoLabel()
    }()
    
    lazy var descriptionLabel: UILabel = {
        return self.makeDescriptionLabel()
    }()
    
    lazy var shareButton: UIButton = {
        return self.makeShareButton()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarHidden(isHidden: true)
        
        self.shareButton.reactive.controlEvents(UIControlEvents.touchUpInside).observeValues {[weak self] (sender) in
            self?.showShareView()
        }
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        self.background.yy_imageURL = self.viewModel.backgroundImageUrl
        self.closeItem.reactive.controlEvents(UIControlEvents.touchUpInside)
            .observeValues { [weak self] (_) in
            self?.popViewController(animated: true)
        }
        self.dayLabel.text = self.viewModel.dayText
        self.infoLabel.text = self.viewModel.infoText
        self.descriptionLabel.attributedText = self.viewModel.descriptionText
            .withFont(Font.sys(size: 13))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 10, alignment: NSTextAlignment.left))
        
        self.shareButton.backgroundColor = UIColor.clear
        
        self.viewModel.shareViewModel.shareAction.values.observeValues { [weak self] (type) in
            self?.share(type: type)
        }
    }

    func share(type: ShareViewModel.OperationType) {
        self.viewModel.isRequest.value = true
        DispatchQueue.global().async {
            if let url = self.viewModel.backgroundImageUrl {
                do {
                    let data = try Data.init(contentsOf: url)
                    if let image = UIImage.init(data: data) {
                        DispatchQueue.main.async {
                            self.viewModel.isRequest.value = false
                            let shareView = SignShareImageView.create(data: self.viewModel.signInfo)
                            shareView.bannerImage.image = image
                            self.view.addSubview(shareView)
                            let shareImage = shareView.buildImage()
                            shareView.removeFromSuperview()
                            if shareImage != nil {
                                self.share(type: type, image: shareImage!)
                            }
                        }
                    }
                } catch {
                }
            }
        }
    }
    
    func share(type: ShareViewModel.OperationType, image: UIImage) {
        switch type {
        case .wxFriend:
            ShareUtil.shareToWxFriendImage(image: image)
            break
        case .wxTimeline:
            ShareUtil.shareToWxTimelineImage(image: image)
            break
        case .qqFriend:
            ShareUtil.shareToQQFriendImage(image: image)
        case .copy:
            UIPasteboard.general.string = ShareInfo.recommendUrl
            MBProgressHUD.showSuccessHUD(text: "复制成功")
        case .more:
            ShareUtil.shareToSystemMore()
        }
    }
    
    func showShareView() {
        let shareController: ShareViewController = ShareViewController.create(viewModel: viewModel.shareViewModel)
        self.rootPresent(viewController: shareController, animated: true)
    }
    
    deinit {
        print("deinit")
    }
}
