//
//  ArticleCommentViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleCommentListViewModel: BaseViewModel, ArticleApi {

    var commentlist: MutableProperty<[JSON]>!
    var fetchCommentlistAction: Action<(), [JSON], RequestError>!
    
    let articleID: String
    init(articleID: String) {
        self.articleID = articleID
        super.init()
        
        self.commentlist = MutableProperty<[JSON]>([])
        
        self.fetchCommentlistAction = Action<(), [JSON], RequestError>
            .init(execute: { (arg0) -> SignalProducer<[JSON], RequestError> in
            return self.createFetchCommentlistSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchCommentlistAction.apply(()).start()
    }
    
    private func createFetchCommentlistSignalProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        
        requestArticleCommentlist(articleID: self.articleID).observeResult { (result) in
            switch result {
            case let .success(data):
                print(data)
                let list = data["data"]["commentlist"].arrayValue
                self.commentlist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
                self.requestError.value = error
            }
        }
        
        return SignalProducer.init(signal)
    }
    
}
