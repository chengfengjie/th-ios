//
//  AddEditNoteViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AddEditNoteViewModel: BaseViewModel {
    
    var noteText: MutableProperty<String>!
    
    let paraContent: JSON
    init(paraContent: JSON) {
        self.paraContent = paraContent
        super.init()
        
        self.noteText = MutableProperty("")
    }

}
