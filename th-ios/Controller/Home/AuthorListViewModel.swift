//
//  AuthorListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/6.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorListViewModel: BaseViewModel, ArticleApi, UserApi {
    
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
    
    var flowUserAction: Action<IndexPath, JSON, RequestError>!
    var cancelFlowAuthorAction: Action<IndexPath, JSON, RequestError>!
    
    var clickAuthorAction: Action<IndexPath, AuthorViewModel, NoError>!
    
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
        
        self.flowUserAction = Action<IndexPath, JSON, RequestError>
            .init(execute: { (indexPath) -> SignalProducer<JSON, RequestError> in
                if self.currentUser.isLogin.value {
                    return self.createFllowUserSignalProducer(indexPath: indexPath)
                } else {
                    return SignalProducer.init(error: RequestError.forbidden)
                }
        })
        
        self.cancelFlowAuthorAction = Action<IndexPath, JSON, RequestError>
            .init(execute: { (indexPath) -> SignalProducer<JSON, RequestError> in
                if self.currentUser.isLogin.value {
                    return self.createCancelFlowAuthorSignalProducer(indexPath: indexPath)
                } else {
                    return SignalProducer.init(error: RequestError.forbidden)
                }
        })
        
        self.clickAuthorAction = Action<IndexPath, AuthorViewModel, NoError>
            .init(execute: { (indexPath) -> SignalProducer<AuthorViewModel, NoError> in
                let id: String = self.authorlist.value[indexPath.row]["id"].stringValue
                let model: AuthorViewModel = AuthorViewModel(authorID: id)
                return SignalProducer.init(value: model)
        })
        
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
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
                self.requestError.value = err
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
                print(data)
                let list = data["data"]["cateauthor"].arrayValue
                self.authorlist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.requestError.value = err
            }
        }
        
        return SignalProducer<[JSON], RequestError>.init(signal)
    }
    
    private func createFllowUserSignalProducer(indexPath: IndexPath) -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestFlowAuthor(authorId: self.authorlist.value[indexPath.row]["id"].stringValue).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                observer.send(value: data)
                observer.sendCompleted()
                self.okMessage.value = "关注成功"
            case let .failure(error):
                observer.send(error: error)
                self.requestError.value = error
            }

        }
        return SignalProducer.init(signal)
    }
    
    private func createCancelFlowAuthorSignalProducer(indexPath: IndexPath) -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestCancelFllowAuthor(authorId: self.authorlist.value[indexPath.row]["id"].stringValue).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                observer.send(value: value)
                observer.sendCompleted()
            case let .failure(error):
                print(error)
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
}
