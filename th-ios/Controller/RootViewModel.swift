//
//  RootViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class RootViewModel: BaseViewModel {
    
    let homeViewModel: HomeViewModel!
    let sameCityMainViewModel: SameCityMainViewModel!
    let qingViewModel: QingViewModel!
    let mineViewModel: MineViewModel!
    
    override init() {
        self.homeViewModel = HomeViewModel()
        self.sameCityMainViewModel = SameCityMainViewModel()
        self.qingViewModel = QingViewModel()
        self.mineViewModel = MineViewModel()
        super.init()
    }
    
}
