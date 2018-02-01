//
//  WeexViewController.swift
//  th-demo
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class WeexViewController: UIViewController {

    let instance: WXSDKInstance = WXSDKInstance()
    
    var weexView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instance.viewController = self
        instance.frame = self.view.frame
        
        instance.onCreate = { [weak self] (v) in
            self?.weexView?.removeFromSuperview()
            self?.weexView = v
            self?.view.addSubview(v!)
        }
        
        instance.onFailed = { (_) in
            
        }
        
        instance.renderFinish = { (v) in
            print(v!)
        }
        
        instance.render(with: URL.init(string: "http://localhost:8000/index.js"), options: [:], data: nil)
    }

}
