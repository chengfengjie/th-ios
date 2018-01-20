//
//  SearchViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/20.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, SearchViewControllerLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeSearchBarLayout()
    }

}

protocol SearchViewControllerLayout {}
extension SearchViewControllerLayout where Self: SearchViewController {
    func makeSearchBarLayout() {
        
    }
}
