//
//  SignViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/11.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

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
    }

    
    deinit {
        print("deinit")
    }
}
