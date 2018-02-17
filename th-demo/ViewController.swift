//
//  ViewController.swift
//  th-demo
//
//  Created by chengfj on 2018/1/25.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import Result

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (signal, observer) = Signal<Int, NoError>.pipe()
        
        signal.observeValues { (val) in
            print(val)
        }
        
        observer.send(value: 100)
        
        let textField: UITextField = UITextField()
        textField.reactive.continuousTextValues.skipNil().observeValues { (text) in
            
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

