//
//  FeedbackViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/12.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class FeedbackViewModel: BaseViewModel, UserApi {

    var text: MutableProperty<String>!
    
    var image: MutableProperty<UIImage?>!
    
    var feedbackTextAction: Action<(), JSON, RequestError>!
    
    var feedbackImageAction: Action<(), JSON, RequestError>!
    
    override init() {
        super.init()
        
        self.text = MutableProperty("")
        self.image = MutableProperty<UIImage?>(nil)
        
        self.feedbackTextAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFeedbackTextSignalProducer()
        })
        
        self.feedbackImageAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFeedbackImageSignalProducer()
        })
    }
    
    private func createFeedbackTextSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestFeedback(text: self.text.value, image: nil).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                self.text.value = ""
                observer.send(value: value)
                observer.sendCompleted()
                self.okMessage.value = "反馈成功"
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFeedbackImageSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestFeedback(text: nil, image: self.image.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                observer.send(value: value)
                observer.sendCompleted()
                self.okMessage.value = "反馈成功"
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
}
