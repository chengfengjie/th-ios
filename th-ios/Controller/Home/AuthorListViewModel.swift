//
//  AuthorListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/6.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorListViewModel: BaseViewModel, ArticleApi {
    
    class MenuItem: NSObject {
        let name: String
        var isSelected: Bool
        let catId: String
        init(dataJSON: JSON) {
            self.catId = dataJSON["catid"].stringValue
            self.name = dataJSON["catname"].stringValue
            self.isSelected = false
            super.init()
        }
    }
    
    var authorCatelist: MutableProperty<[MenuItem]>!
    var authorlist: MutableProperty<[JSON]>!
    
    var fetchAuthorlistAction: Action<String, [JSON], RequestError>!
    var fetchAuthorCateAction: Action<Int, [MenuItem], RequestError>!
    
    var currentCateID: String = "" {
        didSet {
            self.fetchAuthorlistAction.apply(self.currentCateID).start()
        }
    }
    
    override init() {
        super.init()
        
        self.authorCatelist = MutableProperty<[MenuItem]>([])
        self.authorlist = MutableProperty<[JSON]>([])
        
        self.fetchAuthorCateAction = Action<Int, [MenuItem], RequestError>
            .init(execute: { (_) -> SignalProducer<[MenuItem], RequestError> in
            return self.fetchCatelistProducer()
        })
        
        self.fetchAuthorlistAction = Action<String, [JSON], RequestError>
            .init(execute: { (catID) -> SignalProducer<[JSON], RequestError> in
            return self.fetchAithorlistProducer(catID: catID)
        })
        
        self.fetchAuthorCateAction.apply(0).start()
    }
    
    private func fetchCatelistProducer() -> SignalProducer<[MenuItem], RequestError> {
        let (signal, observer) = Signal<[MenuItem], RequestError>.pipe()
        self.isRequest.value = true
        self.requestAuthorCatelist().observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                var list: [MenuItem] = []
                data["data"]["catelist"].arrayValue.forEach({ (item) in
                    list.append(MenuItem.init(dataJSON: item))
                })
                list.first?.isSelected = true
                if let item = list.first {
                    self.currentCateID = item.catId
                }
                self.authorCatelist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.errorMsg.value = err.localizedDescription
            }
        }
        
        return SignalProducer<[MenuItem], RequestError>.init(signal)
    }
    
    private func fetchAithorlistProducer(catID: String) -> SignalProducer<[JSON], RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        self.requestAuthorlist(cateID: self.currentCateID).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                let list = data["data"]["cateauthor"].arrayValue
                self.authorlist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.errorMsg.value = err.localizedDescription
            }
        }
        
        return SignalProducer<[JSON], RequestError>.init(signal)
    }
    
}
