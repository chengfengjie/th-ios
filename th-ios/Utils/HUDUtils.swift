//
//  HUDUtils.swift
//  th-ios
//
//  Created by chengfj on 2018/2/22.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    static let globalSuccessHUD: MBProgressHUD = MBProgressHUD
        .init(view: (UIApplication.shared.delegate as! AppDelegate).window!).then {
            $0.mode = .customView
            $0.isSquare = true
            let successIcon = UIImage.init(named: "Checkmark")!
                .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            $0.customView = UIImageView.init(image: successIcon)
            (UIApplication.shared.delegate as! AppDelegate).window!.addSubview($0)
    }
    class func showSuccessHUD(text: String) {
        globalSuccessHUD.label.text = text
        globalSuccessHUD.show(animated: true)
        globalSuccessHUD.hide(animated: true, afterDelay: 1)
    }
}
