//
//  ViewController.swift
//  th-demo
//
//  Created by chengfj on 2018/1/25.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIButton.init(type: .system).do {
            $0.setTitle("push to controller", for: UIControlState.normal)
            self.view.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.view.snp.centerY)
                make.centerX.equalTo(self.view.snp.centerX)
            })
            $0.addTarget(self, action: #selector(self.pushToController), for: UIControlEvents.touchUpInside)
        }
    }

    @objc func pushToController() {
        navigationController?.pushViewController(NextViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

